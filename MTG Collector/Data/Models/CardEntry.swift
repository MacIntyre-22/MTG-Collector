//
//  CardEntry.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//         Lightweight, CloudKit-synced record of a card inside a collection. Stores only
//         the Scryfall ID plus the user's metadata — the full card data lives locally in
//         CardCache and is resolved on demand via CardStore. This keeps synced data small
//         (only IDs travel to iCloud; card details are re-fetched/cached per device).
//  External Types:
//         CardCache, CardStore, Card

// MARK: Import

import Foundation
import SwiftData

// MARK: Finish

/// The printing finish the user owns. Drives which Scryfall price counts toward a binder's value
/// (decks always price at base). Stored as a raw string for CloudKit friendliness.
enum CardFinish: String, CaseIterable, Codable, Hashable {
    case nonfoil
    case foil
    case etched

    var label: String {
        switch self {
        case .nonfoil: return "Nonfoil"
        case .foil:    return "Foil"
        case .etched:  return "Etched"
        }
    }
}

// MARK: Types

@Model
final class CardEntry {

    // MARK: Stored Properties

    /// NOTE: no @Attribute(.unique) — CloudKit-backed stores do not support unique constraints.
    var id: UUID = UUID()
    var scryfallCardID: String = ""
    var quantity: Int = 1
    /// Raw `CardFinish`. Synced; read/written via the `finish` computed property below.
    var finishRaw: String = CardFinish.nonfoil.rawValue
    var favourite: Bool = false
    var dateAdded: Date = Date()

    /// Which leader slot this card fills when designated ("commander" / "oathbreaker" / "signature").
    /// A leader stays a normal mainboard entry (its data is preserved) — this flag just moves it out
    /// of the board list into its slot and excludes it from the board's card counts/stats. Empty for
    /// ordinary cards. See `DeckRules`.
    var role: String = ""

    /// CloudKit-friendly soft delete + conflict resolution
    var isDeleted: Bool = false
    var updatedAt: Date = Date()

    // MARK: Relationships (CloudKit inverses)

    /// CloudKit requires every relationship to have an inverse. A CardEntry belongs to exactly one
    /// of these at a time (the others stay nil) — they are the inverse targets for Binder.cards and
    /// the Deck boards/commander. SwiftData sets the matching one automatically when the entry is
    /// appended to a collection.
    var binder: Binder?
    var deckMainboard: Deck?
    var deckSideboard: Deck?
    var deckMaybeboard: Deck?

    // MARK: Computed

    /// Typed view over `finishRaw`.
    var finish: CardFinish {
        get { CardFinish(rawValue: finishRaw) ?? .nonfoil }
        set { finishRaw = newValue.rawValue }
    }

    /// Backward-compatible bridge for the text/import/export/snapshot layers, which only express
    /// a foil flag (Moxfield/Archidekt `*F*`). Reading is true for foil *or* etched; writing maps
    /// to foil/nonfoil (etched is set explicitly via `finish`).
    var isFoil: Bool {
        get { finish != .nonfoil }
        set { if newValue { if finish == .nonfoil { finish = .foil } } else { finish = .nonfoil } }
    }

    // MARK: Initializer

    init(scryfallCardID: String, quantity: Int = 1, isFoil: Bool = false, favourite: Bool = false) {
        self.scryfallCardID = scryfallCardID
        self.quantity = quantity
        self.finishRaw = (isFoil ? CardFinish.foil : .nonfoil).rawValue
        self.favourite = favourite
        self.dateAdded = Date()
        self.updatedAt = Date()
    }

    /// Convenience initializer when the full card is already in hand (e.g. adding from search).
    convenience init(card: Card) {
        self.init(scryfallCardID: card.id)
    }
}
