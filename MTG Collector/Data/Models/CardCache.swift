//
//  CardCache.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Local-only cache of full card data, keyed by Scryfall ID. This model is stored in
//         a separate, NON-synced ModelConfiguration so that only lightweight CardEntry IDs
//         travel to CloudKit. Card details are fetched from Scryfall and cached here per
//         device; `fetchedAt` drives the price-refresh interval (see Phase 4).
//  External Types:
//         Card

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
final class CardCache {

    // MARK: Stored Properties

    /// Unique is safe here because CardCache lives in the local-only store, not the CloudKit store.
    @Attribute(.unique) var scryfallCardID: String = ""
    var fetchedAt: Date = Date()
    var card: Card = Card()

    // MARK: Initializer

    init(card: Card) {
        self.scryfallCardID = card.id
        self.card = card
        self.fetchedAt = Date()
    }
}
