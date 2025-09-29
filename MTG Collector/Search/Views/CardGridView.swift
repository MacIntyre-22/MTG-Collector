//
//  CardGridView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct CardGridView: View {
    var card: CardJSON
    
    // check flip state
    @State private var isFlipped: Bool = false
        
    var multiFaced: [CardFaceJSON]? {
        card.cardFaces
    }
    
    // set current face
    var currentFace: CardFaceJSON? {
        guard let faces = multiFaced else { return nil }
        return isFlipped ? faces.last : faces.first
    }
    
    var body: some View {
        VStack{
            // if multifaced
            if let face = currentFace {
                ZStack(alignment: .topTrailing) {
                    CardImageView(maxWidth: 220, imageUrl: face.imageURIs?.normal ?? "")
                    
                    Button {
                        isFlipped.toggle()
                    } label: {
                        Image(systemName: "arrow.left.arrow.right.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(radius: 7)
                    }
                }
            } else {
                // regular card
                CardImageView(maxWidth: 220, imageUrl: card.imageURIs?.normal ?? "")
            }
            
            
            Text(currentFace?.name ?? card.name)
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
                    if let prices = card.prices {
                        ForEach(prices.keys.sorted(), id: \.self) { key in
                            // only display if price has a value
                            if let priceOptional = prices[key], let price = priceOptional, !price.isEmpty {
                                GridPriceWidget(finish: key, price: price)
                            }
                        }
                    }
                }
            }
        }
        .padding(10)
        .background(content: {Color.gray.opacity(0.18)})
        .cornerRadius(10)
    }
    
}

