//
//  CollectionStats.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Stored statistics for a Collection, linked one-to-one. Replaces the old computed
//         properties on Binder/Deck (which can no longer read card data now that CardEntry
//         holds only an ID). Recomputed by StatsUpdater whenever cards change or prices
//         refresh, so reads are cheap. The front end filters which fields it shows per
//         collection type.
//  External Types:
//         Collection, StatsUpdater

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
final class CollectionStats {

    // MARK: Stored Properties

    var collection: Collection?

    /// which board these stats describe (decks): "mainboard" / "sideboard" / "maybeboard"
    var board: String = "mainboard"

    var totalCards: Int = 0
    var uniqueCards: Int = 0
    var totalPriceUSD: Double = 0
    var totalPriceEUR: Double = 0
    var totalPriceTix: Double = 0
    var avgManaCost: Double = 0
    var landCount: Int = 0
    var highestPricedCardID: String = ""

    /// breakdown dictionaries (Codable — persisted directly)
    var rarityBreakdown: [String: Int] = [:]
    var colourBreakdown: [String: Int] = [:]
    var typeBreakdown: [String: Int] = [:]

    var updatedAt: Date = Date()

    // MARK: Initializer

    init(collection: Collection? = nil, board: String = "mainboard") {
        self.collection = collection
        self.board = board
    }
}
