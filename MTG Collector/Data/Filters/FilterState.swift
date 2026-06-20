//
//  FilterState.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Shared filter values for every filter context. A single FilterState is bound to the
//      reusable FilterSheet UI and passed to whichever FilterEngine the calling view injects.
//      Some fields apply only to Scryfall search, others only to a local collection — the
//      sheet hides the irrelevant ones based on the engine kind.

// MARK: Imports

import Foundation

// MARK: Types

/// Which sort fields the UI can offer (shared label set).
enum FilterSort: String, CaseIterable, Identifiable {
    case name, cmc, released
    case usd          // price
    case edhrec       // commander popularity
    case color
    case rarity
    case dateAdded    // collection only

    var id: String { rawValue }

    var label: String {
        switch self {
        case .name: return "Name"
        case .cmc: return "Mana Value"
        case .released: return "Release Date"
        case .usd: return "Price (USD)"
        case .edhrec: return "EDHREC Rank"
        case .color: return "Colour"
        case .rarity: return "Rarity"
        case .dateAdded: return "Date Added"
        }
    }

    /// Scryfall `order` parameter value (only meaningful for the Scryfall engine).
    var scryfallOrder: String {
        switch self {
        case .dateAdded: return "released" // no direct equivalent; fall back
        default: return rawValue
        }
    }
}

struct FilterState {

    // MARK: Shared

    var text: String = ""
    var colors: [String] = []
    var types: [String] = []
    var sets: [String] = []
    var rarities: [String] = []
    var cmcLower: Double = 0
    var cmcUpper: Double = 20
    var sortBy: FilterSort = .name
    var sortDescending: Bool = false

    // MARK: Scryfall only

    var formatLegality: String = ""      // e.g. "standard", "modern", "commander"
    var isCommander: Bool = false        // is:commander
    var producedMana: [String] = []      // produces:{colours}

    // MARK: Collection only

    var foilOnly: Bool = false
    var favouritesOnly: Bool = false

    // MARK: Deck only

    /// Filters a deck board's cards by their legality status in the deck's format (All / Issues /
    /// Legal). Lives here so it's set from the deck filter sheet rather than a separate control.
    var legality: LegalityFilter = .all

    // MARK: Reset

    mutating func reset() {
        self = FilterState()
    }

    /// Reset everything except the free-text query (used by the Search tab's "Clear" so the
    /// typed search term survives a filter clear).
    mutating func resetFilters() {
        let keepText = text
        self = FilterState()
        text = keepText
    }

    /// Whether any Scryfall filter (i.e. anything other than the free-text query) is active.
    /// Drives the filled/outline state of the Search tab's filter button.
    var hasActiveScryfallFilters: Bool {
        !colors.isEmpty
            || !types.isEmpty
            || !sets.isEmpty
            || !rarities.isEmpty
            || !producedMana.isEmpty
            || cmcLower != 0
            || cmcUpper != 20
            || sortBy != .name
            || sortDescending
            || !formatLegality.isEmpty
            || isCommander
    }

    // MARK: Scryfall Query

    /// Builds a Scryfall search query string from the shared + Scryfall-only fields.
    /// Sort order is applied separately via SFAPI.fetchCards(order:descending:).
    func scryfallQuery() -> String {
        var parts: [String] = []

        if !text.isEmpty {
            parts.append(text)
        }
        if !types.isEmpty {
            parts.append("(" + types.map { "type:\($0)" }.joined(separator: " OR ") + ")")
        }
        if !colors.isEmpty {
            parts.append("c:\(colors.joined())")
        }
        if !producedMana.isEmpty {
            parts.append("produces:\(producedMana.joined())")
        }
        if !sets.isEmpty {
            parts.append("(" + sets.map { "set:\($0)" }.joined(separator: " OR ") + ")")
        }
        if !rarities.isEmpty {
            parts.append("(" + rarities.map { "rarity:\($0)" }.joined(separator: " OR ") + ")")
        }
        if !formatLegality.isEmpty {
            parts.append("f:\(formatLegality)")
        }
        if isCommander {
            parts.append("is:commander")
        }

        // CMC range — guard against an inverted slider
        let upper = cmcUpper >= cmcLower ? cmcUpper : 20
        parts.append("cmc>=\(Int(cmcLower))")
        parts.append("cmc<=\(Int(upper))")

        return parts.joined(separator: " ")
    }
}
