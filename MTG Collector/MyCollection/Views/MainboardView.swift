//
//  MainboardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//

import SwiftUI

struct MainboardView: View {
    var deck: Deck
    
    
    // responsive grid
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]
    
    var body: some View {
        LazyVGrid(columns: cardColumns) {
            ForEach(deck.mainboard.sorted(by: { $0.dateAdded > $1.dateAdded})) { entry in
                
                //
                DeckCardView(deck: deck, entry: entry, deleteEntry: {deck.mainboard.removeAll(where: { $0.id == entry.id })})

            }
        }
        
    }
}

