//
//  CardInfoView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardInfoView: View {
    // data
    var card: CardJSON
    
    var body: some View {
        List {
            CardImageView(maxWidth: 250, imageUrl: card.imageURIs?.normal ?? "")
            CollectionControllWidget(card: card)
            
            Text(card.name)
            Text(card.flavorText ?? "")
        }
        .listRowSpacing(10)
    }
}

