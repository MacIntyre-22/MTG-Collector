//
//  CardEntry.swift
//  MTG Collector
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

// MARK: Types

@Model
final class CardEntry {

    // MARK: Stored Properties

    /// NOTE: no @Attribute(.unique) — CloudKit-backed stores do not support unique constraints.
    var id: UUID = UUID()
    var scryfallCardID: String = ""
    var quantity: Int = 1
    var isFoil: Bool = false
    var favourite: Bool = false
    var dateAdded: Date = Date()

    /// CloudKit-friendly soft delete + conflict resolution
    var isDeleted: Bool = false
    var updatedAt: Date = Date()

    // MARK: Initializer

    init(scryfallCardID: String, quantity: Int = 1, isFoil: Bool = false, favourite: Bool = false) {
        self.scryfallCardID = scryfallCardID
        self.quantity = quantity
        self.isFoil = isFoil
        self.favourite = favourite
        self.dateAdded = Date()
        self.updatedAt = Date()
    }

    /// Convenience initializer when the full card is already in hand (e.g. adding from search).
    convenience init(card: Card) {
        self.init(scryfallCardID: card.id)
    }
}
