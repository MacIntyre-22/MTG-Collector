//
//  SuggestionQueryBuilder.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Maps a WeaknessFlag + deck features to a Scryfall query string (colour identity +
//      format injected at runtime) and a plain-English reason. Some weaknesses are structural
//      advice (e.g. needsLessLands) and have no card query. Pure Swift, no SwiftUI.
//      Results are fetched with order = "edhrec" (see DeckSuggestionViewModel).
//  External Types:
//      WeaknessFlag, DeckStatsFeatures, DeckThresholds

// MARK: Imports

import Foundation

// MARK: Builder

struct SuggestionQueryBuilder {

    /// Scryfall query for a weakness, or nil if the weakness is structural advice only.
    func query(for flag: WeaknessFlag, features: DeckStatsFeatures) -> String? {
        let scope = scopeClause(features)
        switch flag {
        case .needsMoreLands:
            return "t:land \(scope)"
        case .needsRamp:
            return "(o:\"add {\" or o:\"search your library for a basic land\") -t:land \(scope)"
        case .needsRemoval:
            return "(o:\"destroy target\" or o:\"exile target\") -t:land \(scope)"
        case .needsCardDraw:
            return "o:\"draw a card\" -t:land \(scope)"
        case .curveTooHigh:
            return "cmc<=2 -t:land \(scope)"
        case .needsMoreCreatures:
            return "t:creature \(scope)"
        case .needsLessLands, .mainboardTooSmall, .mainboardTooLarge:
            return nil // structural — no "find cards" query
        }
    }

    /// Plain-English explanation shown above each suggestion section.
    func reason(for flag: WeaknessFlag, features: DeckStatsFeatures, thresholds t: DeckThresholds) -> String {
        switch flag {
        case .needsMoreLands:
            return "Your deck has \(features.landCount) lands — \(t.landMin)–\(t.landMax) is typical for this deck. Consider adding lands:"
        case .needsLessLands:
            return "Your deck has \(features.landCount) lands — that's above the usual \(t.landMin)–\(t.landMax). Consider trimming a few."
        case .needsRamp:
            return "Only \(features.rampCount) ramp pieces — aim for at least \(t.rampMin). Mana acceleration to consider:"
        case .needsRemoval:
            return "Only \(features.removalCount) removal spells — aim for at least \(t.removalMin). Interaction to consider:"
        case .needsCardDraw:
            return "Only \(features.cardDrawCount) card-draw sources — aim for at least \(t.drawMin). Card advantage to consider:"
        case .curveTooHigh:
            return String(format: "Average mana value is %.1f — that's high for this archetype. Cheaper options:", features.avgCMC)
        case .needsMoreCreatures:
            return "Only \(features.creatureCount) creatures — this strategy usually wants at least \(t.creatureMin). Creatures to consider:"
        case .mainboardTooSmall:
            return "Your deck has \(features.totalCards) cards — this format needs \(t.deckSize)."
        case .mainboardTooLarge:
            return "Your deck has \(features.totalCards) cards — this format allows exactly \(t.deckSize)."
        }
    }

    // MARK: Helpers

    /// "c<=WUG f:commander" — omits the colour clause when colourless and the format clause
    /// for casual (not a real Scryfall format).
    private func scopeClause(_ features: DeckStatsFeatures) -> String {
        var parts: [String] = []
        if !features.colors.isEmpty {
            parts.append("c<=\(features.colors.joined())")
        }
        if features.format != "casual", !features.format.isEmpty {
            parts.append("f:\(features.format)")
        }
        return parts.joined(separator: " ")
    }
}
