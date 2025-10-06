//
//  CollectionControllWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-27.
//

import SwiftUI
import SwiftData

struct CollectionControllWidget: View {
    // environment variables
    @Environment(\.modelContext) var modelContext
    // grab all decks and binders
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    
    // get card to add
    var card: Card
    
    
    var body: some View {
        HStack() {
            
            // MARK: Binders Menu
            Menu("Binders") {
                if !binders.isEmpty {
                    ForEach(binders) { binder in
                        Button(binder.name) {
                            addCard(collection: &binder.cards)
                        }
                    }
                } else {
                    Text("No Binders available")
                        .font(.caption)
                }
            }
            
            // MARK: Decks Menu
            Menu("Decks") {
                if !decks.isEmpty {
                    ForEach(decks) { deck in
                        Menu(deck.name) {
                            Button("Mainboard") {
                                addCard(collection: &deck.mainboard)
                            }
                            Button("Sideboard") {
                                addCard(collection: &deck.sideboard)
                            }
                            Button("Maybeboard") {
                                addCard(collection: &deck.maybeboard)
                            }
                        }
                    }
                } else {
                    Text("No Decks available")
                        .font(.caption)
                }
            }
        }
    }
    
    // MARK: Add Card
    // takes a collection
    private func addCard(collection: inout [CardEntry]) {

        // create cardEntry and add to collection
        let entry = CardEntry(card: card)
        collection.append(entry)

    }
}
