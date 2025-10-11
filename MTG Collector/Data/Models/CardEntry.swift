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
    var quantity: Int = 1
    var isFoil: Bool = false
    var favourite: Bool = false
    
    // relationships
    @Relationship var card: Card

    init(card: Card) {
        self.card = card
    }
}
