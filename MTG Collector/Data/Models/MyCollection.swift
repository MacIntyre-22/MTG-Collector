//
//  MyCollection.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
import Foundation
import SwiftData

@Model
class MyCollection {
    @Relationship(deleteRule: .cascade) var binders: [Binder] = []
    @Relationship(deleteRule: .cascade) var decks: [Deck] = []
    @Relationship(deleteRule: .cascade) var previewCards: [CardEntry] = []
    
    init(binders: [Binder], decks: [Deck], previewCards: [CardEntry]) {
        self.binders = binders
        self.decks = decks
        self.previewCards = previewCards
    }
}
