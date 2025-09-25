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
    var finish: String?
    var isCommander: Bool = false
    var isDisplay: Bool = true
    
    // relationships
    @Relationship var card: Card
    @Relationship var deck: Deck?
    @Relationship var binder: Binder?

    init(card: Card, quantity: Int = 1, finish: String? = nil, isCommander: Bool = false, isDisplay: Bool = true) {
        self.card = card
        self.quantity = quantity
        self.finish = finish
        self.isCommander = isCommander
        self.isDisplay = isDisplay
    }
}
