//
//  CardBoardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct CardBoardView: View {
    var entry: CardEntry
    
    var body: some View {
        VStack {
            CardImageView(maxWidth: 180, imageURIs: entry.card.imageURIs)
                .frame(width: 100)
            Text(entry.card.name)
            Divider()
            
            Text(entry.card.colors.first ?? "No Color")

        
        }
    }
}

