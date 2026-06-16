//
//  CollectionControllWidget.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-27.
//  Purpose:
//      Allows the user to add a card to one of their collections
//  External Types:
//      Binder, Deck, Card, CardEntry

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CollectionControllWidget: View {
    
    // MARK: Stored Properties

    var card: Card
    
    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query(sort: \Binder.editedAt, order: .reverse) var binders: [Binder]
    @Query(sort: \Deck.editedAt, order: .reverse) var decks: [Deck]

    // MARK: View
    
    var body: some View {
        HStack() {
            Menu("Binders") {
                if !binders.isEmpty {
                    ForEach(binders.sorted(by: {$0.pinned && !$1.pinned})) { binder in
                        Button{
                            addCard(collection: &binder.cards, owner: binder)
                        } label: {
                            if binder.pinned {
                                Label(binder.name, systemImage: "pin.fill")
                            } else {
                                Text(binder.name)
                            }
                        }
                    }
                } else {
                    Text("No Binders available")
                        .font(.caption)
                }
            }
            
            Menu("Decks") {
                if !decks.isEmpty {
                    ForEach(decks.sorted(by: {$0.pinned && !$1.pinned})) { deck in
                        Menu {
                            Button("Mainboard") {
                                addCard(collection: &deck.mainboard, owner: deck)
                            }
                            Button("Sideboard") {
                                addCard(collection: &deck.sideboard, owner: deck)
                            }
                            Button("Maybeboard") {
                                addCard(collection: &deck.maybeboard, owner: deck)
                            }
                        } label: {
                            if deck.pinned {
                                Label(deck.name, systemImage: "pin.fill")
                            } else {
                                Text(deck.name)
                            }                        }
                    }
                } else {
                    Text("No Decks available")
                        .font(.caption)
                }
            }
        }
    }
    
    // MARK: Add Card

    /// Cache the full card locally (so it resolves later), add a lightweight entry, refresh stats.
    func addCard(collection: inout [CardEntry], owner: Collection) {
        CardStore.cache(card, context: modelContext)
        collection.append(CardEntry(scryfallCardID: card.id))
        owner.editedAt = Date()
        owner.updatedAt = Date()
        StatsUpdater.update(owner, context: modelContext)
    }
}
