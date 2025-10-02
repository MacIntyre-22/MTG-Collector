//
//  CardEntry.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
import Foundation
import SwiftData

// MARK: Card Entry
@Model
class CardEntry {
    @Attribute(.unique) var id: UUID = UUID()
    var quantity: Int
    var finish: String
    var isCommander: Bool
    var isDisplay: Bool
    
    // relationships
    @Relationship var card: Card

    init(card: Card, quantity: Int = 1, finish: String = "base", isCommander: Bool = false, isDisplay: Bool = false) {
        self.card = card
        self.quantity = quantity
        self.finish = finish
        self.isCommander = isCommander
        self.isDisplay = isDisplay
    }
}
