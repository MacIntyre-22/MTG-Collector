//
//  DeckSuggestionEngine.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Rule-based deck weakness diagnosis (the v1 of the Deck Suggestion Engine). Computes
//      deck stat features from the deck's cards, then flags weaknesses using format +
//      archetype thresholds documented in SuggestionModelPlan.md. Pure Swift, no SwiftUI.
//
//      A Create ML model can later replace `weaknesses(for:)` behind the same interface — the
//      feature extraction here is exactly the labelling input the model would consume.
//  External Types:
//      Deck, CardEntry, Card

// MARK: Imports

import Foundation

// MARK: Archetype

enum DeckArchetype: String, CaseIterable, Identifiable {
    case aggro, control, midrange, combo, ramp, tribal, tokens, stax, spellslinger, casual
    var id: String { rawValue }
    var label: String { rawValue.capitalized }
}

// MARK: Weakness Flags

enum WeaknessFlag: String, Identifiable {
    case needsMoreLands
    case needsLessLands
    case needsRamp
    case needsRemoval
    case needsCardDraw
    case curveTooHigh
    case needsMoreCreatures
    case mainboardTooSmall
    case mainboardTooLarge
    var id: String { rawValue }
}

// MARK: Thresholds

struct DeckThresholds {
    var landMin: Int
    var landMax: Int
    var avgCMCMax: Double
    var removalMin: Int
    var drawMin: Int
    var rampMin: Int
    var creatureMin: Int        // only enforced for creature-based archetypes
    var deckSize: Int
    var enforceMaxSize: Bool     // Commander = exactly 100; constructed has no hard max
}

// MARK: Features

struct DeckStatsFeatures {
    var landCount: Int = 0
    var avgCMC: Double = 0
    var creatureCount: Int = 0
    var removalCount: Int = 0
    var cardDrawCount: Int = 0
    var rampCount: Int = 0
    var totalCards: Int = 0
    var colors: [String] = []           // deck colour identity
    var format: String = "casual"
    var archetype: DeckArchetype = .midrange
}

// MARK: Engine

struct DeckSuggestionEngine {

    // MARK: Feature extraction

    /// Build stat features from a deck's mainboard, resolving card data from the cache lookup.
    func features(for deck: Deck, lookup: [String: Card], archetype: DeckArchetype? = nil) -> DeckStatsFeatures {
        var f = DeckStatsFeatures()
        f.format = deck.ruleType
        var colorSet = Set<String>()
        var cmcSum = 0.0
        var nonLandCount = 0

        for entry in deck.mainboard where !entry.isDeleted {
            let qty = entry.quantity
            f.totalCards += qty
            guard let card = lookup[entry.scryfallCardID] else { continue }

            let text = card.oracleText.lowercased()
            let isLand = card.typeLine.contains("Land")

            if isLand {
                f.landCount += qty
            } else {
                cmcSum += card.cmc * Double(qty)
                nonLandCount += qty
            }

            if card.typeLine.contains("Creature") { f.creatureCount += qty }
            if isRemoval(text) { f.removalCount += qty }
            if isCardDraw(text) { f.cardDrawCount += qty }
            if !isLand && isRamp(text) { f.rampCount += qty }

            colorSet.formUnion(card.colorIdentity)
        }

        f.avgCMC = nonLandCount > 0 ? cmcSum / Double(nonLandCount) : 0
        f.colors = Array(colorSet).sorted()
        f.archetype = archetype ?? infer(from: f)
        return f
    }

    // MARK: Weakness rules

    func weaknesses(for f: DeckStatsFeatures) -> [WeaknessFlag] {
        let t = thresholds(format: f.format, archetype: f.archetype)
        var flags: [WeaknessFlag] = []

        if f.landCount < t.landMin { flags.append(.needsMoreLands) }
        if f.landCount > t.landMax { flags.append(.needsLessLands) }
        if f.avgCMC > t.avgCMCMax { flags.append(.curveTooHigh) }
        if f.removalCount < t.removalMin { flags.append(.needsRemoval) }
        if f.cardDrawCount < t.drawMin { flags.append(.needsCardDraw) }
        if f.rampCount < t.rampMin { flags.append(.needsRamp) }
        if t.creatureMin > 0 && f.creatureCount < t.creatureMin { flags.append(.needsMoreCreatures) }
        if f.totalCards < t.deckSize { flags.append(.mainboardTooSmall) }
        if t.enforceMaxSize && f.totalCards > t.deckSize { flags.append(.mainboardTooLarge) }

        return flags
    }

    // MARK: Archetype inference (simple heuristic; user can override)

    private func infer(from f: DeckStatsFeatures) -> DeckArchetype {
        let creatureRatio = f.totalCards > 0 ? Double(f.creatureCount) / Double(f.totalCards) : 0
        if creatureRatio > 0.45 && f.avgCMC < 2.5 { return .aggro }
        if creatureRatio > 0.5 { return .tribal }
        if f.removalCount >= 8 && f.cardDrawCount >= 8 && creatureRatio < 0.2 { return .control }
        if f.rampCount >= 10 { return .ramp }
        return f.format == "commander" ? .midrange : .midrange
    }

    // MARK: Threshold table

    func thresholds(format: String, archetype: DeckArchetype) -> DeckThresholds {
        // format defaults
        var t: DeckThresholds
        switch format {
        case "commander", "oathbreaker", "brawl":
            t = DeckThresholds(landMin: 36, landMax: 40, avgCMCMax: 3.5, removalMin: 10, drawMin: 10, rampMin: 10, creatureMin: 0, deckSize: 100, enforceMaxSize: true)
        case "modern", "pioneer":
            t = DeckThresholds(landMin: 22, landMax: 24, avgCMCMax: 2.2, removalMin: 8, drawMin: 4, rampMin: 2, creatureMin: 0, deckSize: 60, enforceMaxSize: false)
        case "standard":
            t = DeckThresholds(landMin: 24, landMax: 26, avgCMCMax: 3.0, removalMin: 8, drawMin: 4, rampMin: 2, creatureMin: 0, deckSize: 60, enforceMaxSize: false)
        case "legacy", "vintage":
            t = DeckThresholds(landMin: 18, landMax: 22, avgCMCMax: 2.0, removalMin: 8, drawMin: 4, rampMin: 2, creatureMin: 0, deckSize: 60, enforceMaxSize: false)
        case "pauper":
            t = DeckThresholds(landMin: 22, landMax: 24, avgCMCMax: 2.5, removalMin: 8, drawMin: 4, rampMin: 2, creatureMin: 0, deckSize: 60, enforceMaxSize: false)
        default: // casual + anything unrecognised
            t = DeckThresholds(landMin: 22, landMax: 26, avgCMCMax: 3.5, removalMin: 6, drawMin: 3, rampMin: 2, creatureMin: 0, deckSize: 60, enforceMaxSize: false)
        }

        // archetype overrides (only the fields the archetype meaningfully changes)
        switch archetype {
        case .aggro:
            t.landMin = 18; t.landMax = 22; t.avgCMCMax = 2.0; t.creatureMin = 20; t.removalMin = 6; t.drawMin = 2; t.rampMin = 0
        case .control:
            t.landMin = max(t.landMin, 24); t.avgCMCMax = 2.5; t.removalMin = 10; t.drawMin = 8; t.creatureMin = 0
        case .midrange:
            t.avgCMCMax = max(t.avgCMCMax, 3.0); t.creatureMin = 14
        case .combo:
            t.removalMin = 4; t.drawMin = 6; t.rampMin = 4; t.creatureMin = 0
        case .ramp:
            t.landMin = 36; t.landMax = 40; t.avgCMCMax = 5.0; t.rampMin = 12; t.creatureMin = 10
        case .tribal:
            t.creatureMin = 28
        case .tokens:
            t.creatureMin = 10
        case .stax:
            t.removalMin = 10
        case .spellslinger:
            t.drawMin = 8; t.creatureMin = 0
        case .casual:
            break
        }
        return t
    }

    // MARK: Oracle-text heuristics

    private func isRemoval(_ text: String) -> Bool {
        text.contains("destroy target") || text.contains("exile target") ||
        text.contains("destroy all") || text.contains("exile all") ||
        (text.contains("deals") && text.contains("damage to")) ||
        text.contains("loses all abilities") || text.contains("-x/-x")
    }

    private func isCardDraw(_ text: String) -> Bool {
        text.contains("draw a card") || text.contains("draw two") ||
        text.contains("draw three") || text.contains("draw cards")
    }

    private func isRamp(_ text: String) -> Bool {
        text.contains("add {") || text.contains("add one mana") || text.contains("add two mana") ||
        (text.contains("search your library") && text.contains("land"))
    }
}
