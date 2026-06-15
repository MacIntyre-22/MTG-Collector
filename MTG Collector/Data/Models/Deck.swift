//
//  Deck.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//         A deck of cards with mainboard / sideboard / maybeboard. Inherits shared fields
//         from Collection. Card-data statistics live in the linked CollectionStats (kept
//         current by StatsUpdater); `isLegal` is also maintained there since a CardEntry no
//         longer carries legality data directly. Quantity-based counts stay computed.
//  External Types:
//         CardEntry, Collection, CollectionStats

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
final class Deck: Collection {

    // MARK: Stored Properties

    var ruleType: String = "casual"

    /// Maintained by StatsUpdater (needs card legality data, which lives in CardCache).
    var isLegal: Bool = true

    @Relationship var commander: CardEntry?

    /// Cards arrays (boards)
    @Relationship(deleteRule: .cascade) var mainboard: [CardEntry] = []
    @Relationship(deleteRule: .cascade) var sideboard: [CardEntry] = []
    @Relationship(deleteRule: .cascade) var maybeboard: [CardEntry] = []

    // MARK: Quantity-based Computed Properties (no card data needed)

    var activeMainboard: [CardEntry] {
        mainboard.filter { !$0.isDeleted }
    }

    var cardCount: Int {
        activeMainboard.reduce(0) { $0 + $1.quantity }
    }

    var uniqueCount: Int {
        activeMainboard.count
    }

    // MARK: Stats Convenience (read stored CollectionStats)

    var totalPrice: Double { stats?.totalPriceUSD ?? 0 }
    var landCount: Int { stats?.landCount ?? 0 }
    var avgManaCost: Double { stats?.avgManaCost ?? 0 }
    var cardTypeCount: [String: Int] { stats?.typeBreakdown ?? [:] }
    var manaTypeCount: [String: Int] { stats?.colourBreakdown ?? [:] }

    // MARK: Initializer

    init(name: String, notes: String = "", ruleType: String = "casual") {
        self.ruleType = ruleType
        super.init(name: name, notes: notes)
    }
}
