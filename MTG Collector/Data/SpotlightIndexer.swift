//
//  SpotlightIndexer.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-20.
//  Purpose:
//      Model-aware layer over `Spotlight`. Builds the rich result descriptions (card count, value,
//      format), indexes binders/decks with a square cover + ranking hint, and indexes the user's
//      favourite cards with their art so they're findable by name in iOS Search. Favourite ids are
//      diffed against the last run so un-favourited cards are pruned from the index.
//  External Types:
//      Binder, Deck, CardEntry, Card, CardStore, StatsStore, AppCurrency, ImageCache, Spotlight
//

// MARK: Imports

import SwiftData
import UIKit

// MARK: Indexer

@MainActor
enum SpotlightIndexer {

    /// UserDefaults key holding the Scryfall ids indexed on the previous run (for pruning).
    private static let indexedCardsKey = "spotlightFavouriteCardIDs"

    // MARK: Entry point

    /// Re-index every collection and favourite card. Cheap to re-run — CoreSpotlight dedupes by id,
    /// so this just refreshes descriptions/thumbnails and prunes anything no longer favourited.
    static func reindex(binders: [Binder], decks: [Deck], context: ModelContext, currency: AppCurrency) {
        for binder in binders where !binder.isDeleted && !binder.isGeneral {
            Spotlight.index(
                kind: .binder,
                id: binder.id,
                name: binder.name,
                image: binder.coverUIImage,
                description: description(for: binder, context: context, currency: currency),
                rankingHint: binder.pinned ? 100 : 50
            )
        }
        for deck in decks where !deck.isDeleted {
            Spotlight.index(
                kind: .deck,
                id: deck.id,
                name: deck.name,
                image: deck.coverUIImage,
                description: description(for: deck, context: context, currency: currency),
                keywords: [deck.ruleType],
                rankingHint: deck.pinned ? 100 : 50
            )
        }

        Task { await indexLooseCards(binders: binders, decks: decks, context: context) }
    }

    // MARK: Collection descriptions

    private static func description(for binder: Binder, context: ModelContext, currency: AppCurrency) -> String {
        let value = currency.format(currency.total(StatsStore.stats(for: binder, context: context)))
        let cards = binder.cardCount
        return "\(cards) card\(cards == 1 ? "" : "s") · \(value)"
    }

    private static func description(for deck: Deck, context: ModelContext, currency: AppCurrency) -> String {
        let value = currency.format(currency.total(StatsStore.stats(for: deck, context: context)))
        let cards = deck.cardCount
        return "\(deck.ruleType.capitalized) · \(cards) card\(cards == 1 ? "" : "s") · \(value)"
    }

    // MARK: Loose cards (favourites + My Hold)

    /// Index every card that isn't reachable by a named collection: favourites (anywhere) plus
    /// everything in the My Hold catch-all. Named binders/decks are found by their own name, so
    /// their cards don't need individual entries. Prunes anything indexed before but now gone.
    private static func indexLooseCards(binders: [Binder], decks: [Deck], context: ModelContext) async {
        let allEntries = binders.flatMap { $0.cards }
            + decks.flatMap { $0.mainboard + $0.sideboard + $0.maybeboard }
        let favourites = allEntries.filter { !$0.isDeleted && $0.favourite }
        let generalCards = binders.first(where: { $0.isGeneral })?.cards.filter { !$0.isDeleted } ?? []

        let cardIDs = Set((favourites + generalCards).map { $0.scryfallCardID }.filter { !$0.isEmpty })

        // Prune cards indexed before but no longer favourited / in My Hold.
        let previous = Set(UserDefaults.standard.stringArray(forKey: indexedCardsKey) ?? [])
        Spotlight.removeCards(ids: Array(previous.subtracting(cardIDs)))
        UserDefaults.standard.set(Array(cardIDs), forKey: indexedCardsKey)

        guard !cardIDs.isEmpty else { return }
        let ids = Array(cardIDs)
        await CardStore.prime(ids, context: context)
        let lookup = CardStore.lookup(for: ids, context: context)

        for id in ids {
            guard let card = lookup[id] else { continue }
            let art = await cardArt(for: card)
            Spotlight.indexCard(
                id: id,
                name: card.name,
                description: cardDescription(card),
                keywords: cardKeywords(card),
                image: art
            )
        }
    }

    private static func cardDescription(_ card: Card) -> String {
        var parts: [String] = []
        if !card.typeLine.isEmpty { parts.append(card.typeLine) }
        parts.append(card.setName.isEmpty ? card.set.uppercased() : card.setName)
        if let usd = Double(card.prices.usd), usd > 0 {
            parts.append(String(format: "$%.2f", usd))
        }
        return parts.filter { !$0.isEmpty }.joined(separator: " · ")
    }

    private static func cardKeywords(_ card: Card) -> [String] {
        [card.setName, card.set, card.typeLine, card.artist].filter { !$0.isEmpty }
    }

    /// Load a small card image via the shared cache (network only on a miss — favourites are bounded).
    private static func cardArt(for card: Card) async -> UIImage? {
        let candidates = [card.imageURIs.small, card.imageURIs.normal,
                          card.cardFaces.first?.imageURIs.small ?? "",
                          card.cardFaces.first?.imageURIs.normal ?? ""]
        guard let urlString = candidates.first(where: { !$0.isEmpty }),
              let url = URL(string: urlString) else { return nil }
        return await ImageCache.shared.load(url)
    }
}
