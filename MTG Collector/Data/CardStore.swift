//
//  CardStore.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Resolves CardEntry IDs into full Card data via the local CardCache. On a cache
//         miss the card is fetched from Scryfall and cached. This is the single bridge
//         between lightweight synced records (CardEntry / scryfallCardID) and the card
//         details the UI needs.
//  External Types:
//         CardCache, Card, SFAPI

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@MainActor
enum CardStore {

    // MARK: Cache Lookups

    /// Synchronous cache-only lookup. Returns nil on a miss.
    static func cached(_ id: String, context: ModelContext) -> Card? {
        guard !id.isEmpty else { return nil }
        var descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { $0.scryfallCardID == id })
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first?.card
    }

    /// Cache-only lookup for many IDs at once. Missing IDs are simply absent from the result.
    static func lookup(for ids: [String], context: ModelContext) -> [String: Card] {
        // Array (not Set) — SwiftData #Predicate supports `[T].contains`.
        let wanted = Array(Set(ids.filter { !$0.isEmpty }))
        guard !wanted.isEmpty else { return [:] }

        let descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { wanted.contains($0.scryfallCardID) })
        let entries = (try? context.fetch(descriptor)) ?? []

        var result: [String: Card] = [:]
        for entry in entries {
            result[entry.scryfallCardID] = entry.card
        }
        return result
    }

    // MARK: Resolution

    /// Resolve a card by ID: cache hit, otherwise fetch from Scryfall and cache it.
    @discardableResult
    static func resolve(_ id: String, context: ModelContext) async -> Card? {
        if let hit = cached(id, context: context) { return hit }
        guard let json = await SFAPI.fetchCardId(id: id) else { return nil }
        let card = SFAPI.JSONtoModel(json: json)
        cache(card, context: context)
        return card
    }

    /// Prime the cache for a whole collection in one pass: look up what's cached, then resolve the
    /// misses in batches of 75 via /cards/collection (instead of one /cards/{id} request per cell).
    /// Also warms the image cache for everything found, so art is ready before cells appear.
    static func prime(_ ids: [String], context: ModelContext) async {
        let unique = Array(Set(ids.filter { !$0.isEmpty }))
        guard !unique.isEmpty else { return }

        let have = lookup(for: unique, context: context)
        let missing = unique.filter { have[$0] == nil }

        // Warm images for already-cached cards immediately.
        prefetchImages(Array(have.values))

        guard !missing.isEmpty else { return }

        for chunk in stride(from: 0, to: missing.count, by: 75).map({ Array(missing[$0..<min($0 + 75, missing.count)]) }) {
            let identifiers = chunk.map { CardIdentifierJSON(id: $0) }
            let (found, _) = await SFAPI.fetchCardCollection(identifiers: identifiers)
            let cards = found.map(SFAPI.JSONtoModel)
            cache(cards, context: context)
            prefetchImages(cards)
        }
    }

    /// Queue the normal-size art for a set of cards into the image cache.
    private static func prefetchImages(_ cards: [Card]) {
        let urls = cards.compactMap { card -> URL? in
            let s = card.imageURIs.normal.isEmpty ? card.imageURIs.large : card.imageURIs.normal
            return URL(string: s)
        }
        ImageCache.shared.prefetch(urls)
    }

    // MARK: Caching

    /// Insert a new cache entry or refresh an existing one (updating fetchedAt).
    static func cache(_ card: Card, context: ModelContext) {
        guard !card.id.isEmpty else { return }
        let id = card.id
        var descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { $0.scryfallCardID == id })
        descriptor.fetchLimit = 1

        if let existing = (try? context.fetch(descriptor))?.first {
            existing.card = card
            existing.fetchedAt = Date()
        } else {
            context.insert(CardCache(card: card))
        }
    }

    /// Cache a batch of cards (e.g. from a /cards/collection resolve).
    static func cache(_ cards: [Card], context: ModelContext) {
        for card in cards {
            cache(card, context: context)
        }
    }
}
