//
//  CollectionStats.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Stored statistics for a collection. Lives in the LOCAL cache store (never synced — it's
//         entirely derived from the synced cards + refetched card data), keyed by collectionID
//         rather than a SwiftData relationship (relationships can't cross the synced/cache store
//         boundary). Recomputed by StatsUpdater on card changes / price refresh / after a sync
//         import, so reads stay cheap. Looked up via StatsStore.
//  External Types:
//         StatsStore, StatsUpdater

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
final class CollectionStats {

    // MARK: Stored Properties

    /// Foreign key to the owning collection (its `id`). Used instead of a relationship because
    /// CollectionStats is local-only and the Collection is synced — they can't be related across
    /// stores.
    var collectionID: String = ""

    /// which board these stats describe (decks): "mainboard" / "sideboard" / "maybeboard"
    var board: String = "mainboard"

    var totalCards: Int = 0
    var uniqueCards: Int = 0
    /// The single canonical collection value, always stored in USD (the common price). Every card's
    /// finish price is normalised to USD here — pulled from the USD market first, else FX-converted
    /// from another market. The display layer converts this to whatever currency the user picks, so
    /// adding a new currency never touches stored data.
    var totalPriceUSD: Double = 0
    var avgManaCost: Double = 0
    /// Number of non-land cards averaged into `avgManaCost`. Stored so the whole-collection widget
    /// can combine several collections' averages exactly (weighted mean), not approximately.
    var manaCount: Int = 0
    var landCount: Int = 0
    var highestPricedCardID: String = ""
    /// The USD value of the highest-priced card, so aggregates can pick the dearest across collections.
    var highestPricedCardValue: Double = 0

    /// breakdown dictionaries (Codable — persisted directly)
    var rarityBreakdown: [String: Int] = [:]
    var colourBreakdown: [String: Int] = [:]
    var typeBreakdown: [String: Int] = [:]
    /// Count per set (keyed by set name) and per owned finish (nonfoil/foil/etched).
    var setBreakdown: [String: Int] = [:]
    var finishBreakdown: [String: Int] = [:]

    var updatedAt: Date = Date()

    // MARK: Initializer

    init(collectionID: String = "", board: String = "mainboard") {
        self.collectionID = collectionID
        self.board = board
    }
}
