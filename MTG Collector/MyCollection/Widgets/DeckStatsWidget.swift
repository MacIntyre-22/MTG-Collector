//
//  DeckStatsWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-04.
//

import SwiftUI

struct DeckStatsWidget: View {
    var deck: Deck
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Legal: \(deck.isLegal ? "Yes" : "No")")
            Text("Card Count: \(deck.cardCount)")
            Text("Land Count: \(deck.landCount)")
            Text("Avg Mana: \(deck.avgManaCost)")
            
            
        }
    }
}

