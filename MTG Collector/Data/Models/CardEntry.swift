//
//  CardEntry.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         CardEntry stores a Card Model and information about that card, relating to the collection the entry is in
//  External Types:
//         Card

// MARK: Import

import Foundation
import SwiftData

// MARK: Types

@Model
class CardEntry {
    
    // MARK: Stored Properties
    
    @Attribute(.unique) var id: UUID = UUID()
    var quantity: Int = 1
    var isFoil: Bool = false
    var favourite: Bool = false
    var dateAdded: Date
    
    /// The card model it holds
    @Relationship var card: Card

    // MARK: Initializer
    
    init(card: Card) {
        self.card = card
        self.dateAdded = Date()
    }
}
