//
//  MaybeboardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//

import SwiftUI

struct MaybeboardView: View {
    var deck: Deck
    
    
    // responsive grid
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    var body: some View {
        LazyVGrid(columns: cardColumns) {
            ForEach(deck.maybeboard) { entry in
                
                //
                DeckCardView(deck: deck, entry: entry, deleteEntry: {deck.maybeboard.removeAll(where: { $0.id == entry.id })})

            }
        }
        
    }
}

