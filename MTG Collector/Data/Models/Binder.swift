//
//  Binder.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//         A card binder. Inherits shared fields from Collection. Card-data statistics
//         (price, rarity, type, colour breakdowns) live in the linked CollectionStats and
//         are kept current by StatsUpdater — they can no longer be computed here because a
//         CardEntry holds only an ID, not card data. Quantity-based counts stay computed
//         since they need no card data.
//  External Types:
//         CardEntry, Collection, CollectionStats

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@available(iOS 26, *)
@Model
final class Binder: Collection {

    // MARK: Stored Properties

    var coverImage: String = ""

    /// Permanent catch-all binder (My Hold tab). Created on first launch, never deleted.
    var isGeneral: Bool = false

    /// Backing store for the binder's cards. Optional because CloudKit requires to-many
    /// relationships to be optional; the rest of the app uses the non-optional `cards` facade.
    @Relationship(deleteRule: .cascade, inverse: \CardEntry.binder) var cardsStore: [CardEntry]?

    /// Non-optional accessor so existing code can read / append / removeAll without unwrapping.
    /// (Computed → not persisted; SwiftData only stores `cardsStore`.)
    var cards: [CardEntry] {
        get { cardsStore ?? [] }
        set { cardsStore = newValue }
    }

    // MARK: Quantity-based Computed Properties (no card data needed)

    /// Active (non-soft-deleted) entries
    var activeCards: [CardEntry] {
        cards.filter { !$0.isDeleted }
    }

    var cardCount: Int {
        activeCards.reduce(0) { $0 + $1.quantity }
    }

    var uniqueCardCount: Int {
        activeCards.count
    }

    // Stats (price, rarity/colour/type breakdowns, highest card) live in the local CollectionStats
    // and are read via StatsStore.stats(for:context:) — they need a context, so not on the model.

    // MARK: Initializer

    init(name: String, notes: String = "", coverImage: String = "", isGeneral: Bool = false) {
        self.coverImage = coverImage
        self.isGeneral = isGeneral
        super.init(name: name, notes: notes)
    }
}
