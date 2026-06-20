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

    // MARK: Card attributes
    // Build the Scryfall query for Search and are mirrored locally by CollectionFilterEngine, so
    // a binder/deck filters on the same fields (only ones with no cached data are hidden by the UI).

    var formatLegality: String = ""      // e.g. "standard", "modern", "commander"
    var isCommander: Bool = false        // is:commander
    var producedMana: [String] = []      // produces:{colours}
    var colorIdentity: [String] = []     // id:{colours} — Commander colour identity
    var oracleText: String = ""          // o:"…"      — rules-text contains
    var keyword: String = ""             // keyword:…  — ability keyword (flying, deathtouch…)
    var artist: String = ""              // a:"…"
    var powerLower: Double = 0           // pow>=
    var powerUpper: Double = 15          // pow<=  (15 = no upper bound)
    var toughnessLower: Double = 0       // tou>=
    var toughnessUpper: Double = 15      // tou<=  (15 = no upper bound)
    var priceMaxUSD: Double = 0          // usd<=  (0 = no cap)
    var printFlags: [String] = []        // is:foil, is:fullart, is:reprint, is:reserved, is:promo, is:textless

    // MARK: Collection only

    /// Raw `CardFinish` values to show. Empty = all finishes. e.g. ["foil", "etched"].
    var finishes: [String] = []
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
            || !colorIdentity.isEmpty
            || !oracleText.isEmpty
            || !keyword.isEmpty
            || !artist.isEmpty
            || powerLower != 0
            || powerUpper != 15
            || toughnessLower != 0
            || toughnessUpper != 15
            || priceMaxUSD != 0
            || !printFlags.isEmpty
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
        if !colorIdentity.isEmpty {
            parts.append("id:\(colorIdentity.joined())")
        }
        if !oracleText.isEmpty {
            parts.append("o:\"\(oracleText)\"")
        }
        if !keyword.isEmpty {
            parts.append("keyword:\(keyword.replacingOccurrences(of: " ", with: ""))")
        }
        if !artist.isEmpty {
            parts.append("a:\"\(artist)\"")
        }
        for flag in printFlags {
            parts.append("is:\(flag)")
        }
        if powerLower > 0 { parts.append("pow>=\(Int(powerLower))") }
        if powerUpper < 15 { parts.append("pow<=\(Int(powerUpper))") }
        if toughnessLower > 0 { parts.append("tou>=\(Int(toughnessLower))") }
        if toughnessUpper < 15 { parts.append("tou<=\(Int(toughnessUpper))") }
        if priceMaxUSD > 0 { parts.append("usd<=\(Int(priceMaxUSD))") }

        // CMC range — guard against an inverted slider
        let upper = cmcUpper >= cmcLower ? cmcUpper : 20
        parts.append("cmc>=\(Int(cmcLower))")
        parts.append("cmc<=\(Int(upper))")

        return parts.joined(separator: " ")
    }
}
