//
//  DeckColors.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Computes a deck's colour identity from its cards and stores it on `Deck.colorIdentity`.
//      Driven by the designated leaders when the format has them (a commander deck's colours = its
//      commander's colour identity); otherwise the union of the mainboard. Called whenever a leader
//      is designated (always overriding), and to seed a deck that has no colours yet. Manual edits
//      (in the deck's edit sheet) persist until the next leader change re-sets them.
//  External Types:
//      Deck, CardEntry, CardStore, Card
//

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@MainActor
enum DeckColors {

    /// WUBRG display order.
    private static let order = ["W", "U", "B", "R", "G"]

    /// Recompute and store the deck's colour identity. Uses the leaders when present (the MTG rule
    /// for commander/oathbreaker decks), else the mainboard. Cards not yet cached are skipped.
    static func refresh(_ deck: Deck, context: ModelContext) {
        let source = deck.activeLeaders.isEmpty ? deck.activeMainboard : deck.activeLeaders
        let lookup = CardStore.lookup(for: source.map(\.scryfallCardID), context: context)

        var identity = Set<String>()
        for entry in source {
            if let card = lookup[entry.scryfallCardID] {
                identity.formUnion(card.colorIdentity)
            }
        }
        deck.colorIdentity = order.filter { identity.contains($0) }
    }
}
