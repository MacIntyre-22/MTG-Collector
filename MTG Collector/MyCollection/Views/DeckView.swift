//
//  DeckView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct DeckView: View {
    var deck: Deck
    
    var body: some View {
        Text(deck.name)
    }
}

