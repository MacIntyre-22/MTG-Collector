//
//  Binder.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         Model for a card binder. Holds info about the binder and the actual card array. Computed properties calculate stats as changes are made.
//  External Types:
//         CardEntry

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
class Binder {
    
    // MARK: Stored Properties
    
    /// Binder info
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    var notes: String
    var coverImage: String
    var createdAt: Date
    var editedAt: Date
    
    /// Some controls for the binders view
    var showPreviews: Bool = true
    var showControls: Bool = true
    var pinned: Bool = false
    var showCover = true
    
    /// Array of CardEntries to store all cards added to this binder
    @Relationship var cards: [CardEntry] = []

    // MARK: Computed Properties
    
    /// Total card count
    var cardCount: Int {
        cards.reduce(0) { $0 + $1.quantity }
    }

    /// Unique card count
    var uniqueCardCount: Int {
        cards.count
    }

    /// Total price of cards
    /// Only checks the cards base price
    var totalPrice: Double {
        
        ///for each entry and start at 0
        cards.reduce(0) { total, entry in
            let price = Double(entry.card.prices.usd) ?? 0
            return total + price * Double(entry.quantity)
        }
    }

    /// Find the highest priced card
    var highestPricedCard: CardEntry? {
        
        /// use .max to return the CardEntry with the higher price of two CardEntries
        cards.max(by: {
            let price0 = Double($0.card.prices.usd)
            let price1 = Double($1.card.prices.usd)
            return price0 ?? 0 < price1 ?? 0
        })
    }

    /// Total amount of card rarities stored in a dictionary
    /// Allows me to loop through the dict in a view and not set conditions for 0 values, because values only exists if there are at least 1
    var rarities: [String: Int] {
        var counts: [String: Int] = [:]
        for entry in cards {
            
            /// Either creates a dict item or adds the quantity of the entry
            counts[entry.card.rarity, default: 0] += entry.quantity
        }
        return counts
    }

    /// Total amount of cards per mana type
    /// Using a dictionary for the same concept as the rarities dictionary
    var manaTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        /// Double loop as each card could have multiple mana types
        for entry in cards {
            for mana in entry.card.colorIdentity {
                counts[mana, default: 0] += entry.quantity
            }
        }
        return counts
    }

    /// Total amount of cards per their type
    /// Using a dictionary for the same concept as the rarities dictionary
    var cardTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in cards {
            /// get the main type by splitting the type line by "-"
            let mainType = entry.card.typeLine.components(separatedBy: "—")[0].trimmingCharacters(in: .whitespaces)
            counts[mainType, default: 0] += entry.quantity
        }
        return counts
    }
    
    // MARK: Initalizer
    
    init(name: String, notes: String = "", coverImage: String = "") {
        self.name = name
        self.notes = notes
        self.coverImage = coverImage
        self.createdAt = Date()
        self.editedAt = Date()
    }
}
