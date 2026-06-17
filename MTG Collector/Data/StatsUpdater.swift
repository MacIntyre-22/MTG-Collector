//
//  StatsUpdater.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Recomputes a Collection's stored CollectionStats from its card entries, resolving
//         card data through the local CardCache. Call after cards are added/removed, after
//         quantity changes, or after a price refresh. Cards not yet in the cache are skipped
//         (counts catch up once their data is fetched).
//  External Types:
//         Collection, Binder, Deck, CollectionStats, CardEntry, CardStore, Card

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@MainActor
enum StatsUpdater {

    /// Recompute and store stats for a collection (binder, or a deck's mainboard).
    static func update(_ collection: Collection, context: ModelContext) {
        let entries = activeEntries(for: collection)
        let lookup = CardStore.lookup(for: entries.map { $0.scryfallCardID }, context: context)

        // Find or create the linked stats object
        let stats: CollectionStats
        if let existing = collection.stats {
            stats = existing
        } else {
            stats = CollectionStats(collection: collection)
            context.insert(stats)
            collection.stats = stats
        }

        var totalCards = 0
        var totalUSD = 0.0
        var totalEUR = 0.0
        var totalTix = 0.0
        var cmcSum = 0.0
        var cmcCount = 0
        var landCount = 0
        var rarity: [String: Int] = [:]
        var colour: [String: Int] = [:]
        var type: [String: Int] = [:]
        var highestID = ""
        var highestPrice = 0.0
        var deckLegal = true

        let ruleType = (collection as? Deck)?.ruleType

        for entry in entries {
            let qty = entry.quantity
            totalCards += qty

            guard let card = lookup[entry.scryfallCardID] else { continue }

            // prices
            let usd = Double(card.prices.usd) ?? 0
            let eur = Double(card.prices.eur) ?? 0
            let tix = Double(card.prices.tix) ?? 0
            totalUSD += usd * Double(qty)
            totalEUR += eur * Double(qty)
            totalTix += tix * Double(qty)

            if usd > highestPrice {
                highestPrice = usd
                highestID = card.id
            }

            // mana curve (exclude lands from the average, matching MTG convention)
            if !card.typeLine.contains("Land") {
                cmcSum += card.cmc
                cmcCount += 1
            } else {
                landCount += qty
            }

            // rarity breakdown
            if !card.rarity.isEmpty {
                rarity[card.rarity, default: 0] += qty
            }

            // colour breakdown (by colour identity)
            for mana in card.colorIdentity {
                colour[mana, default: 0] += qty
            }

            // type breakdown (main type, before the em dash)
            let mainType = card.typeLine
                .components(separatedBy: "—")[0]
                .trimmingCharacters(in: .whitespaces)
            if !mainType.isEmpty {
                type[mainType, default: 0] += qty
            }

            // deck legality
            if let ruleType, let status = card.legalities[ruleType], status != "legal" {
                deckLegal = false
            }
        }

        stats.totalCards = totalCards
        stats.uniqueCards = entries.count
        stats.totalPriceUSD = totalUSD
        stats.totalPriceEUR = totalEUR
        stats.totalPriceTix = totalTix
        stats.avgManaCost = cmcCount > 0 ? cmcSum / Double(cmcCount) : 0
        stats.landCount = landCount
        stats.highestPricedCardID = highestID
        stats.rarityBreakdown = rarity
        stats.colourBreakdown = colour
        stats.typeBreakdown = type
        stats.updatedAt = Date()

        if let deck = collection as? Deck {
            deck.isLegal = deckLegal
        }
    }

    // MARK: Helpers

    private static func activeEntries(for collection: Collection) -> [CardEntry] {
        if let binder = collection as? Binder {
            return binder.activeCards
        } else if let deck = collection as? Deck {
            return deck.activeMainboard
        }
        return []
    }
}
