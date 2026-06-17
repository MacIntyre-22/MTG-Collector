//
//  DeckSuggestionEngine.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Scaffolding for the on-device Deck Suggestion Engine (Extended Phase 1). The pipeline is:
//          deck stats -> DeckProfile -> WeaknessDetector -> Scryfall queries -> suggestions.
//      The Core ML model plugs in later by conforming to `WeaknessDetector`; for now a simple
//      threshold-based `HeuristicWeaknessDetector` stands in so the feed is functional and the
//      seam is proven. Queries are scoped to the deck's colour identity + format + EDHREC rank.
//
//      TODO(ml): replace HeuristicWeaknessDetector with a Create ML tabular model
//      (see SuggestionModelPlan.md). This is a Pro feature — gate behind Settings.isPro once IAP lands.
//  External Types:
//      Deck, CardJSON, SFAPI
//

// MARK: Imports

import Foundation

// MARK: Inputs

/// SwiftData-free snapshot of a deck used to detect weaknesses (so the detector can be unit-tested
/// and the ML model never touches SwiftData).
struct DeckProfile {
    var totalCards: Int
    var landCount: Int
    var avgManaCost: Double
    /// Colour identity as a Scryfall string, e.g. "rg" (empty = colourless/unknown).
    var colourIdentity: String
    /// Scryfall format name, or "" if the deck's rule type isn't a Scryfall format.
    var format: String
}

// MARK: Weakness

enum DeckWeakness: String, CaseIterable, Identifiable {
    case needsLands
    case curveTooHigh
    case needsRemoval
    case needsCardDraw

    var id: String { rawValue }

    var title: String {
        switch self {
        case .needsLands: return "More Lands"
        case .curveTooHigh: return "Lower the Curve"
        case .needsRemoval: return "Add Removal"
        case .needsCardDraw: return "Card Advantage"
        }
    }

    /// Plain-English reason shown with the suggestion group.
    var reason: String {
        switch self {
        case .needsLands: return "Your land count looks low — these help you hit your land drops."
        case .curveTooHigh: return "Your average mana value is high — cheaper cards smooth your curve."
        case .needsRemoval: return "Light on interaction — removal answers your opponent's threats."
        case .needsCardDraw: return "Add card advantage to keep cards flowing into your hand."
        }
    }

    /// Scryfall query for cards that address this weakness, scoped to identity + format.
    func query(identity: String, format: String) -> String {
        var parts: [String] = []
        switch self {
        case .needsLands:
            parts.append("type:land")
        case .curveTooHigh:
            parts.append("cmc<=2 -type:land")
        case .needsRemoval:
            parts.append("(oracle:destroy or oracle:exile) (type:instant or type:sorcery)")
        case .needsCardDraw:
            parts.append("oracle:\"draw a card\" -type:land")
        }
        if !identity.isEmpty { parts.append("id<=\(identity)") }
        if !format.isEmpty { parts.append("f:\(format)") }
        parts.append("game:paper")
        return parts.joined(separator: " ")
    }
}

// MARK: Detector (ML seam)

protocol WeaknessDetector {
    func weaknesses(for profile: DeckProfile) -> [DeckWeakness]
}

/// Placeholder for the Core ML model — simple thresholds. Replace with the trained tabular model.
struct HeuristicWeaknessDetector: WeaknessDetector {
    func weaknesses(for profile: DeckProfile) -> [DeckWeakness] {
        var result: [DeckWeakness] = []

        let landTarget = Int(Double(max(profile.totalCards, 1)) * 0.38)
        if profile.landCount < landTarget {
            result.append(.needsLands)
        }
        if profile.avgManaCost > 3.3 {
            result.append(.curveTooHigh)
        }
        // Generic improvements always offered while the detector is a stub.
        result.append(.needsRemoval)
        result.append(.needsCardDraw)
        return result
    }
}

// MARK: Suggestions

struct DeckSuggestionGroup: Identifiable {
    let id = UUID()
    var weakness: DeckWeakness
    var cards: [CardJSON]
}

// MARK: Engine

@MainActor
struct DeckSuggestionEngine {

    var detector: WeaknessDetector = HeuristicWeaknessDetector()
    var perWeakness = 8

    /// Scryfall formats we can pass through as `f:`; other rule types (e.g. "casual") are dropped.
    private static let scryfallFormats: Set<String> = [
        "standard", "pioneer", "modern", "legacy", "vintage", "pauper",
        "commander", "brawl", "historic", "alchemy", "explorer", "penny", "premodern", "oathbreaker"
    ]

    func suggestions(for deck: Deck) async -> [DeckSuggestionGroup] {
        let profile = profile(for: deck)

        var groups: [DeckSuggestionGroup] = []
        for weakness in detector.weaknesses(for: profile) {
            let query = weakness.query(identity: profile.colourIdentity, format: profile.format)
            let cards = await SFAPI.fetchCards(query: query, order: "edhrec", descending: false)
            if !cards.isEmpty {
                groups.append(DeckSuggestionGroup(weakness: weakness, cards: Array(cards.prefix(perWeakness))))
            }
        }
        return groups
    }

    private func profile(for deck: Deck) -> DeckProfile {
        let identity = (deck.stats?.colourBreakdown.keys ?? [:].keys)
            .map { $0.lowercased() }
            .sorted()
            .joined()
        let format = Self.scryfallFormats.contains(deck.ruleType) ? deck.ruleType : ""

        return DeckProfile(
            totalCards: deck.cardCount,
            landCount: deck.landCount,
            avgManaCost: deck.avgManaCost,
            colourIdentity: identity,
            format: format
        )
    }
}
