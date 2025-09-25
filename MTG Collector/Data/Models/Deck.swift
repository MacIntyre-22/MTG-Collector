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
    
    @Relationship(deleteRule: .cascade, inverse: \CardEntry.deck) var mainboard: [CardEntry] = []

    
    // computed properties
    // update on change
    var cardCount: Int {
        // start at 0 and add each card in the mainboard ONLY
        mainboard.reduce(0) { $0 + $1.quantity }
    }
    
    var landCount: Int {
        // filter by lands
        mainboard.filter { $0.card.typeLine.contains("Land") }
        // start at 0 and add each card in the mainboard ONLY
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
        mainboard.allSatisfy { entry in
            // check if the deck type has a vlaue of legal in the cards data
            // makes sure every card is legal in the format
            // currently only commander and standard are supported deck types
            entry.card.legalities[ruleType ?? ""] == "legal"
        }
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
            let typeLine = entry.card.typeLine
            // get the maintype not the sub type
            let mainType = typeLine.components(separatedBy: "—")[0].trimmingCharacters(in: .whitespaces)
            counts[mainType, default: 0] += entry.quantity
        }
        return counts
    }
    
    // total cards of each mana count
    var manaTypeCount: [String: Int] {
        // empty dict
        var counts: [String: Int] = [:]
        for entry in mainboard {
            // for each acrd in mainboard add the colour id to dict or add 1
            for mana in entry.card.colorIdentity {
                counts[mana, default: 0] += 1
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
