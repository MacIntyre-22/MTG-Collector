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
            Text(deck.name)
            Divider()
            Text(deck.ruleType)
            Text("\(deck.cardCount)")
        }
    }
}

