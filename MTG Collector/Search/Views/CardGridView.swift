//
//  CardGridView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct CardGridView: View {
    var card: Card
    
    // check flip state
    @State private var isFlipped: Bool = false
        
    var multiFaced: [CardFace]? {
        card.cardFaces
    }
    
    // set current face
    var currentFace: CardFace? {
        guard let faces = multiFaced else { return nil }
        return isFlipped ? faces.last : faces.first
    }
    
    var body: some View {
        VStack{
            // if multifaced
            if let face = currentFace {
                ZStack(alignment: .topTrailing) {
                    CardImageView(maxWidth: 220, imageUrl: face.imageURIs.normal)
                    
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
                CardImageView(maxWidth: 220, imageUrl: card.imageURIs.normal)
            }
            
            
            Text(currentFace?.name ?? card.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    // show rarity
                    if !card.rarity.isEmpty {
                        GridRarityWidget(rarity: card.rarity)
                    }
                    // show price
                    // display each price from prices obj
                    if !card.prices.usd.isEmpty {
                        GridPriceWidget(finish: "Base", price: card.prices.usd)
                    }
                    
                    if !card.prices.usdFoil.isEmpty {
                        GridPriceWidget(finish: "Foil", price: card.prices.usdFoil)
                    }
                    
                    if !card.prices.usdEtched.isEmpty {
                        GridPriceWidget(finish: "Etched", price: card.prices.usdEtched)
                    }
                }
            }
        }
        .padding(10)
        .background(content: {Color.gray.opacity(0.18)})
        .cornerRadius(10)
    }
    
}

