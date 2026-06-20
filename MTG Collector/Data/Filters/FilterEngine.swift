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
            if !filters.finishes.isEmpty && !filters.finishes.contains(entry.finish.rawValue) { return false }
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

    /// Mirrors the Scryfall query the search engine builds, evaluated locally against cached card
    /// data. Every clause is an AND, matching `scryfallQuery()`. Filters with no local backing
    /// data aren't offered by the sheet, so they never reach here.
    private func matches(card: Card, filters: FilterState) -> Bool {
        // Name (Search's free-text field; collection contexts leave this empty)
        if !filters.text.isEmpty,
           !card.name.localizedCaseInsensitiveContains(filters.text) {
            return false
        }
        // Colours (Scryfall c:) — card is/contains all selected colours
        if !filters.colors.isEmpty,
           !filters.colors.allSatisfy({ card.colors.contains($0) }) {
            return false
        }
        // Colour identity (Scryfall id:) — card identity fits within the selected colours
        if !filters.colorIdentity.isEmpty,
           !card.colorIdentity.allSatisfy({ filters.colorIdentity.contains($0) }) {
            return false
        }
        // Produces (Scryfall produces:) — card produces all selected colours
        if !filters.producedMana.isEmpty,
           !filters.producedMana.allSatisfy({ card.producedMana.contains($0) }) {
            return false
        }
        // Types — type line mentions one of the selected types
        if !filters.types.isEmpty,
           !filters.types.contains(where: { card.typeLine.localizedCaseInsensitiveContains($0) }) {
            return false
        }
        // Rarities
        if !filters.rarities.isEmpty,
           !filters.rarities.contains(card.rarity) {
            return false
        }
        // Sets
        if !filters.sets.isEmpty,
           !filters.sets.contains(card.set) {
            return false
        }
        // Mana value range (guard an inverted slider, as the query builder does)
        let upper = filters.cmcUpper >= filters.cmcLower ? filters.cmcUpper : 20
        if card.cmc < filters.cmcLower || card.cmc > upper {
            return false
        }
        // Power / toughness (string stats — "*"/absent fail an active range)
        if !passesStat(card.power, lower: filters.powerLower, upper: filters.powerUpper, cap: 15) {
            return false
        }
        if !passesStat(card.toughness, lower: filters.toughnessLower, upper: filters.toughnessUpper, cap: 15) {
            return false
        }
        // Format legality (Scryfall f:) — legal or restricted counts as playable
        if !filters.formatLegality.isEmpty {
            let status = card.legalities[filters.formatLegality]
            if status != "legal" && status != "restricted" { return false }
        }
        // Can be commander (Scryfall is:commander) — local heuristic
        if filters.isCommander, !canBeCommander(card) {
            return false
        }
        // Printing flags (Scryfall is:…) — every selected flag must hold
        for flag in filters.printFlags where !hasPrintFlag(card, flag) {
            return false
        }
        // Oracle text contains (Scryfall o:)
        if !filters.oracleText.isEmpty, !oracleTextContains(card, filters.oracleText) {
            return false
        }
        // Keyword (Scryfall keyword:)
        if !filters.keyword.isEmpty,
           !card.keywords.contains(where: { $0.localizedCaseInsensitiveContains(filters.keyword) }) {
            return false
        }
        // Artist (Scryfall a:)
        if !filters.artist.isEmpty,
           !card.artist.localizedCaseInsensitiveContains(filters.artist) {
            return false
        }
        // Max price (Scryfall usd<=) — active only above 0; card needs a parseable price at/under it
        if filters.priceMaxUSD > 0 {
            guard let usd = Double(card.prices.usd), usd <= filters.priceMaxUSD else { return false }
        }
        return true
    }

    // MARK: Match helpers

    /// A string stat (power/toughness) passes when its range is inactive, or it parses to a number
    /// inside [lower, upper]. Non-numeric ("*", "1+*") or absent stats fail an *active* range —
    /// matching Scryfall, where `pow>=0` only returns cards that actually have power.
    private func passesStat(_ raw: String, lower: Double, upper: Double, cap: Double) -> Bool {
        if lower <= 0 && upper >= cap { return true }       // full range = filter off
        guard let value = Double(raw) else { return false }
        return value >= lower && value <= upper
    }

    /// Approximates Scryfall `is:commander`: a legendary creature, or any card whose rules text
    /// explicitly says it can be a commander (planeswalker commanders, backgrounds, etc.).
    private func canBeCommander(_ card: Card) -> Bool {
        let type = card.typeLine.lowercased()
        if type.contains("legendary") && type.contains("creature") { return true }
        return card.oracleText.localizedCaseInsensitiveContains("can be your commander")
    }

    /// Whether a printing flag holds, for the flags we cache locally. Collection contexts only ever
    /// offer `reserved`; any unsupported flag never matches (so it can't silently pass).
    private func hasPrintFlag(_ card: Card, _ flag: String) -> Bool {
        switch flag {
        case "reserved": return card.reserved
        case "foil":     return card.finishes.contains("foil")
        default:         return false
        }
    }

    /// Oracle-text search across the card and any of its faces (DFCs carry text per face).
    private func oracleTextContains(_ card: Card, _ needle: String) -> Bool {
        if card.oracleText.localizedCaseInsensitiveContains(needle) { return true }
        return card.cardFaces.contains { $0.oracleText.localizedCaseInsensitiveContains(needle) }
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
