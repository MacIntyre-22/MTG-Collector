//
//  DeckRules.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Single source of truth for which "leader" cards a deck designates, based on its game mode
//      (`Deck.ruleType`). Commander/Brawl name a commander; Oathbreaker names an oathbreaker plus a
//      signature spell. The whole leader UI is driven by this list, so supporting a new format is
//      one case here — no front-end changes. Roles are stored on `CardEntry.role`.
//

// MARK: Imports

import Foundation

// MARK: Slot

/// One designated-card slot for a game mode (e.g. "Commander", "Signature Spell").
struct DeckLeaderSlot: Identifiable, Hashable {
    /// Stored on `CardEntry.role`. Stable key — don't rename once shipped.
    let role: String
    /// User-facing slot title.
    let label: String
    /// How many cards may occupy this slot (Commander allows 2 for partner pairs).
    let maxCount: Int

    var id: String { role }
}

// MARK: Rules

enum DeckRules {

    /// The leader slots a deck of this game mode designates. Empty for formats with no leader
    /// (Standard, Modern, etc.). Add a `case` to support a new format.
    static func leaderSlots(for ruleType: String) -> [DeckLeaderSlot] {
        switch ruleType.lowercased() {
        case "commander", "brawl", "historic brawl", "tiny leaders", "pauper commander":
            return [DeckLeaderSlot(role: "commander", label: "Commander", maxCount: 2)]
        case "oathbreaker":
            return [
                DeckLeaderSlot(role: "oathbreaker", label: "Oathbreaker", maxCount: 1),
                DeckLeaderSlot(role: "signature", label: "Signature Spell", maxCount: 1)
            ]
        default:
            return []
        }
    }

    /// Whether this game mode designates any leader cards at all.
    static func hasLeaders(for ruleType: String) -> Bool {
        !leaderSlots(for: ruleType).isEmpty
    }

    /// The expected mainboard size for a game mode, and whether it's an exact count (singleton
    /// formats) or a minimum (constructed). `nil` for casual / unknown, where size isn't enforced.
    static func deckSize(for ruleType: String) -> (target: Int, exact: Bool)? {
        switch ruleType.lowercased() {
        case "commander", "pauper commander": return (100, true)
        case "brawl", "historic brawl":       return (60, true)
        case "oathbreaker":                   return (60, true)
        case "tiny leaders":                  return (50, true)
        case "standard", "pioneer", "modern", "legacy", "vintage", "pauper":
            return (60, false)
        default:                              return nil
        }
    }

    /// The slot definition for a stored role, if the current rule type still has it.
    static func slot(role: String, ruleType: String) -> DeckLeaderSlot? {
        leaderSlots(for: ruleType).first { $0.role == role }
    }
}
