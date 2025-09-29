//
//  CardGridView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct CardGridView: View {
    var card: CardJSON
    
    var body: some View {
        VStack{
            CardImageView(maxWidth: 220, imageUrl: card.imageURIs?.normal ?? "")
            Text(card.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    // show rarity
                    if let rarity = card.rarity {
                        GridRarityWidget(rarity: rarity)
                    }
                    // show price
                    if let price = card.prices?.usd {
                        GridPriceWidget(price: price)
                    }
                }
            }
        }
        .padding(10)
        .background(content: {Color.gray.opacity(0.18)})
        .cornerRadius(10)
    }
}

