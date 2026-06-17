//
//  FilterEngine.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      The swappable filter engines. A calling view injects an engine; the shared FilterSheet
//      UI never changes. Adding a new filter context = a new engine conformance, zero UI work.
//        • ScryfallFilterEngine   — FilterState -> Scryfall query -> [CardJSON]
//        • CollectionFilterEngine — FilterState -> filtered/sorted [CardEntry] (local)
//  External Types:
//      FilterState, SFAPI, CardJSON, CardEntry, Card, CardStore

// MARK: Imports

import Foundation
import SwiftData

// MARK: Protocol

protocol FilterEngine {
    associatedtype Result
    func apply(filters: FilterState) async -> [Result]
}

// MARK: Scryfall Engine

/// Reads FilterState, builds a Scryfall query, fires the API, returns raw CardJSON.
struct ScryfallFilterEngine: FilterEngine {
    func apply(filters: FilterState) async -> [CardJSON] {
        await SFAPI.fetchCards(
            query: filters.scryfallQuery(),
            order: filters.sortBy.scryfallOrder,
            descending: filters.sortDescending
        )
    }
}

// MARK: Collection Engine

/// Filters and sorts a local set of CardEntry values. Card-attribute filters (colour, type,
/// CMC, rarity) require the cached Card, resolved via CardStore; entry-level filters (foil,
/// favourite) read CardEntry directly.
@MainActor
struct CollectionFilterEngine: FilterEngine {

    /// The entries to filter (e.g. a binder's cards or a deck board).
    let entries: [CardEntry]
    let context: ModelContext

    func apply(filters: FilterState) async -> [CardEntry] {
        // Start from active, entry-level-filtered entries
        var working = entries.filter { entry in
            if entry.isDeleted { return false }
            if filters.foilOnly && !entry.isFoil { return false }
            if filters.favouritesOnly && !entry.favourite { return false }
            return true
        }

        // Resolve cards once for attribute filtering + sorting
        let lookup = CardStore.lookup(for: working.map { $0.scryfallCardID }, context: context)

        // Card-attribute filters (skip an entry only if its card is known and fails a filter)
        working = working.filter { entry in
            guard let card = lookup[entry.scryfallCardID] else {
                // Unknown card data: keep it unless a text search is active
                return filters.text.isEmpty
            }
            return matches(card: card, filters: filters)
        }

        return sort(working, filters: filters, lookup: lookup)
    }

    // MARK: Matching

    private func matches(card: Card, filters: FilterState) -> Bool {
        if !filters.text.isEmpty,
           !card.name.localizedCaseInsensitiveContains(filters.text) {
            return false
        }
        if !filters.colors.isEmpty,
           !filters.colors.allSatisfy({ card.colorIdentity.contains($0) }) {
            return false
        }
        if !filters.types.isEmpty,
           !filters.types.contains(where: { card.typeLine.localizedCaseInsensitiveContains($0) }) {
            return false
        }
        if !filters.rarities.isEmpty,
           !filters.rarities.contains(card.rarity) {
            return false
        }
        if !filters.sets.isEmpty,
           !filters.sets.contains(card.set) {
            return false
        }
        let upper = filters.cmcUpper >= filters.cmcLower ? filters.cmcUpper : 20
        if card.cmc < filters.cmcLower || card.cmc > upper {
            return false
        }
        return true
    }

    // MARK: Sorting

    private func sort(_ entries: [CardEntry], filters: FilterState, lookup: [String: Card]) -> [CardEntry] {
        let sorted = entries.sorted { lhs, rhs in
            switch filters.sortBy {
            case .dateAdded:
                return lhs.dateAdded < rhs.dateAdded
            case .name:
                return name(lhs, lookup) < name(rhs, lookup)
            case .cmc:
                return card(lhs, lookup)?.cmc ?? 0 < card(rhs, lookup)?.cmc ?? 0
            case .usd:
                return price(lhs, lookup) < price(rhs, lookup)
            case .edhrec:
                return card(lhs, lookup)?.edhrecRank ?? Int.max < card(rhs, lookup)?.edhrecRank ?? Int.max
            case .released, .rarity, .color:
                return name(lhs, lookup) < name(rhs, lookup)
            }
        }
        return filters.sortDescending ? sorted.reversed() : sorted
    }

    private func card(_ entry: CardEntry, _ lookup: [String: Card]) -> Card? {
        lookup[entry.scryfallCardID]
    }

    private func name(_ entry: CardEntry, _ lookup: [String: Card]) -> String {
        card(entry, lookup)?.name ?? ""
    }

    private func price(_ entry: CardEntry, _ lookup: [String: Card]) -> Double {
        Double(card(entry, lookup)?.prices.usd ?? "") ?? 0
    }
}
