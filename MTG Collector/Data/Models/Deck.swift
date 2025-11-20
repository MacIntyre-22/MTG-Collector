//
//  Deck.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         Model for a deck of cards. Holds info about the deck and the three different card arrays.
//         Computed properties calculate stats as changes are made, ONLY TO THE MAINBOARD ARRAY.
//  External Types:
//         CardEntry

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
class Deck {
    
    // MARK: Stored Properties
    
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    var notes: String
    var ruleType: String
    var createdAt: Date
    var editedAt: Date
    var commander: CardEntry?
    
    /// some controls
    var showPreviews: Bool = true
    var showControls: Bool = true
    var pinned: Bool = false
    var showCover = true
    
    /// Cards arrays (boards), to hold the cards
    @Relationship var mainboard: [CardEntry] = []
    @Relationship var sideboard: [CardEntry] = []
    @Relationship var maybeboard: [CardEntry] = []

    // MARK: Computed Properties

    /// Total card count
    var cardCount: Int {
        mainboard.reduce(0) { $0 + $1.quantity }
    }
    
    /// Unique card count
    var uniqueCount: Int {
        mainboard.count
    }
    
    /// Total count of cards by typeline: Land (Important for deck bilding in MTG)
    var landCount: Int {
        /// Filter array by lands
        mainboard.filter { entry in
            return entry.card.typeLine.contains("Land")
        }
        /// return last total plus card quantity to get total lands in the array
        /// cant use .count as their may be only 1 entry that holds multiple lands
        .reduce(0) { $0 + $1.quantity }
    }

    /// Average mana cost
    var avgManaCost: Double {
        let costs = mainboard.compactMap { $0.card.cmc }
        guard !costs.isEmpty else { return 0 }
        /// add up then divide by the amount of cards that have a mana cost
        return costs.reduce(0, +) / Double(costs.count)
    }
    
    /// Legal Status
    var isLegal: Bool {
        /// assumes everycard is legal until it finds one that isnt
        var temp: Bool = true
        
        for entry in mainboard {
            for legality in entry.card.legalities {
                /// any value other than "legal" make the deck not legal (ex: banned, restricted, not_legal)
                if legality.key == ruleType && legality.value != "legal" {
                    temp = false
                }
            }
        }
        return temp
    }
    
    /// Total amount of cards by type stored in a dictionary
    /// Allows me to loop through the dict in a view and not set conditions for 0 values, because values only exists if there are at least 1
    var cardTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in mainboard {
            /// get the main type by splitting the type line by "-"
            let mainType = entry.card.typeLine.components(separatedBy: "—")[0].trimmingCharacters(in: .whitespaces)
            counts[mainType, default: 0] += entry.quantity
        }
        return counts
    }
    
    /// Total amount of cards per mana type
    /// Using a dictionary for the same concept as the card type count dictionary
    var manaTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in mainboard {
            for mana in entry.card.colorIdentity {
                counts[mana, default: 0] += entry.quantity
            }
        }
        return counts
    }
    
    /// Total price of the deck
    var totalPrice: Double {
        mainboard.reduce(0) { total, entry in
            let price = Double(entry.card.prices.usd) ?? 0
            return total + price * Double(entry.quantity)
        }
    }

    // MARK: Initializer
    
    init(name: String, notes: String = "", coverimage: String = "", ruleType: String = "casual") {
        self.name = name
        self.notes = notes
        self.ruleType = ruleType
        self.createdAt = Date()
        self.editedAt = Date()
    }

}
