//
//  SideboardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//  Purpose:
//      Displays the cards in the sideboard for a deck
//  External Types:
//      Deck, DeckCardView

// MARK: Imports

import SwiftUI

// MARK: Types

struct SideboardView: View {
    
    // MARK: Stored Properties

    var deck: Deck
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    // MARK: View
    
    var body: some View {
        
        LazyVGrid(columns: cardColumns) {
            ForEach(deck.sideboard.sorted(by: { $0.dateAdded > $1.dateAdded})) { entry in
                DeckCardView(deck: deck, entry: entry, deleteEntry: {deck.sideboard.removeAll(where: { $0.id == entry.id })})
            }
        }
    }
}

