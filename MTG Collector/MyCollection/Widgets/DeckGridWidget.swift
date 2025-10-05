//
//  DeckGridWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-26.
//

import SwiftUI

struct DeckGridWidget: View {
    var deck: Deck
    
    var body: some View {
        VStack {
            Image("MtgDeck")
                .resizable()
                .renderingMode(.template)
                .scaledToFill()
                .foregroundColor(.primary)
                .frame(width: 125)
            Text(deck.name)
                .bold()
            
        }
        .foregroundColor(.primary)
        .padding(10)
        .background(Color.gray.opacity(0.18))
        .cornerRadius(10)
        
    }
}

