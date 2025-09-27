//
//  Binder.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import Foundation
import SwiftData

// MARK: Collection
@Model
class Binder {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var notes: String?
    var coverImage: String?
    var createdAt: Date = Date()
    
    @Relationship var cards: [CardEntry] = []


    var cardCount: Int {
        // add total quantity
        cards.reduce(0) { $0 + $1.quantity }
    }

    var uniqueCardCount: Int {
        // just count total items because entries are always unique
        cards.count
    }

    var totalPrice: Double {
        // get each price
        cards.reduce(0) { total, entry in
            // convert to Double
            let price = Double(entry.card.prices?.usd ?? "0") ?? 0
            // add price of entry and duplicates
            return total + price * Double(entry.quantity)
        }
    }

    var highestPricedCard: CardEntry? {
        cards.max(by: {
            // compare last highest price to new card
            let price0 = Double($0.card.prices?.usd ?? "0")
            let price1 = Double($1.card.prices?.usd ?? "0")
            return price0 ?? 0 < price1 ?? 0
        })
    }

    // rarities dict
    var rarities: [String: Int] {
        var counts: [String: Int] = [:]
        for entry in cards {
            // create dict item or add 1
            counts[entry.card.rarity ?? "None", default: 0] += entry.quantity
        }
        return counts
    }

    // manatypes dict
    var manaTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in cards {
            // unwrap
            if let colors = entry.card.colorIdentity {
                // count or default to 0
                for mana in colors {
                    counts[mana, default: 0] += 1
                }
            }
        }
        return counts
    }

    // totals of card types as a dict
    var cardTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in cards {
            // unwrap
            if let typeLine = entry.card.typeLine {
                // get the main type, not the subtype
                let mainType = typeLine.components(separatedBy: "—")[0].trimmingCharacters(in: .whitespaces)
                counts[mainType, default: 0] += entry.quantity
            }
        }
        
        return counts
    }
    
    init(id: UUID, name: String, notes: String? = nil, coverImage: String? = nil, createdAt: Date) {
        self.id = id
        self.name = name
        self.notes = notes
        self.coverImage = coverImage
        self.createdAt = createdAt
    }


}
