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
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    var notes: String
    var coverImage: String
    var ruleType: String
    var createdAt: Date
    var commander: CardEntry?
    
    // some controls
    var showPreviews: Bool = true
    var showControls: Bool = false
    var pinned: Bool = false
    var showCover = true
    
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
            return entry.card.typeLine.contains("Land")
        }
        // add quantity
        .reduce(0) { $0 + $1.quantity }
    }

    // average mana cost
    var avgManaCost: Double {
        // filter out nils if any
        let costs = mainboard.compactMap { $0.card.cmc }
        // check if empty
        guard !costs.isEmpty else { return 0 }
        // add up then divide by the amount of cards that have a mana cost
        return costs.reduce(0, +) / Double(costs.count)
    }
    
    // is deck as a whole legal
    var isLegal: Bool {
        // assumes everycard is legal until it finds one that isnt
        var temp: Bool = true
        
        // get ruletype
        for entry in mainboard {
            // check card for ruletype and see if legal or not
            // unless casual
            for legality in entry.card.legalities {
                // other values that are not "legal" still make the deck not legal (ex: banned, restricted, not_legal)
                if legality.key == ruleType && legality.value != "legal" {
                    temp = false
                }
            }
        }
        return temp
    }
    
    // get an array of all contained mana types
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
            // get the main type, not the subtype
            // separates (Legendary Creature - Human)
            // i just want legendary creature, as subtypes are alot more diverse and are not relevant
            let mainType = entry.card.typeLine.components(separatedBy: "—")[0].trimmingCharacters(in: .whitespaces)
            // create the dict where the parsed string is the key and count is value
            counts[mainType, default: 0] += entry.quantity
        }
        return counts
    }
    
    // total cards of each mana count
    var manaTypeCount: [String: Int] {
        var counts: [String: Int] = [:]
        
        for entry in mainboard {
            // count or default to 0
            for mana in entry.card.colorIdentity {
                counts[mana, default: 0] += entry.quantity
            }
        }
        return counts
    }


    // only require a name for the deck
    init(name: String, notes: String = "", coverimage: String = "", ruleType: String = "casual") {
        self.name = name
        self.notes = notes
        self.ruleType = ruleType
        self.createdAt = Date()
        self.coverImage = coverimage
    }

}
