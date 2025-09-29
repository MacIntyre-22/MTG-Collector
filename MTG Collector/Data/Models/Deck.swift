//
//  Deck.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
import Foundation
import SwiftData

// MARK: Deck
@Model
class Deck {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var notes: String?
    var ruleType: String?
    var commander: Card?
    var createdAt: Date
    
    @Relationship var mainboard: [CardEntry] = []
    @Relationship var sideboard: [CardEntry] = []
    @Relationship var maybeboard: [CardEntry] = []

    
    // computed properties
    // update on change
    var cardCount: Int {
        // start at 0 and add each card in the mainboard ONLY
        mainboard.reduce(0) { $0 + $1.quantity }
    }
    
    // count lands
    var landCount: Int {
        // sort by land
        mainboard.filter { entry in
            // unwrap
            if let typeLine = entry.card.typeLine {
                return typeLine.contains("Land")
            }
            return false
        }
        // add quantity
        .reduce(0) { $0 + $1.quantity }
    }

    
    var avgManaCost: Double {
        // filter out nils if any and unwrap
        let costs = mainboard.compactMap { $0.card.cmc }
        // check if empty
        guard !costs.isEmpty else { return 0 }
        // add up then divide by the amount of cards that have a mana cost
        return costs.reduce(0, +) / Double(costs.count)
    }
    
    // is deck as a whole legal
    var isLegal: Bool {
        // get ruletype
        guard let rule = ruleType?.lowercased() else { return false }

//        // loop through each card and check legalities

        return true
    }
    
    // get an array of all contained mana tyoes
    var manaTypes: [String] {
        // based off mana count
        // grab any key where the value is greater than 1
        // gets the colour identity of the set
        return manaTypeCount.compactMap { $0.value > 0 ? $0.key : nil }.sorted()
    }
    
    // totals of card types as a dict
    var cardTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in mainboard {
            // unwrap
            if let typeLine = entry.card.typeLine {
                // get the main type, not the subtype
                let mainType = typeLine.components(separatedBy: "—")[0].trimmingCharacters(in: .whitespaces)
                counts[mainType, default: 0] += entry.quantity
            }
        }
        
        return counts
    }

    
    // total cards of each mana count
    var manaTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in mainboard {
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


    
    init(id: UUID, name: String, notes: String? = nil, ruleType: String? = nil, commander: Card? = nil, createdAt: Date) {
        self.id = id
        self.name = name
        self.notes = notes
        self.ruleType = ruleType
        self.commander = commander
        self.createdAt = createdAt
    }

}
