//
//  CardGridView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct CardGridView: View {
    var card: Card
    
    var showPreviews: Bool = false
    var isFoil: Bool = false
    var showNames: Bool = false
    
    // check flip state
    @State private var isFlipped: Bool = false
    
    
    // grab card faces if any
    var multiFaced: [CardFace]? {
        card.cardFaces
    }
    
    var gradFoil: LinearGradient = LinearGradient(
                                        colors: [.blue, .purple, .pink, .orange, .yellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
    
    var body: some View {
        VStack{
            
            ZStack {
                // if multifaced
                if let faces = multiFaced, faces.count > 1 {
                    // Front face
                    ZStack {
                        CardImageView(maxWidth: 220, name: faces.first!.name, imageURIs: faces.first!.imageURIs)
                        // foil check
                        if isFoil {
                            gradFoil.opacity(0.3)
                        }
                    }
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                    // Back face
                    ZStack {
                        CardImageView(maxWidth: 220, name: faces.last!.name, imageURIs: faces.last!.imageURIs)
                        // foil check
                        if isFoil {
                            gradFoil.opacity(0.3)
                        }
                    }
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    
                } else {
                    // Single faced card
                    ZStack {
                        CardImageView(maxWidth: 220, name: card.name, imageURIs: card.imageURIs)
                        // foil check
                        if isFoil {
                            gradFoil.opacity(0.3)
                        }
                    }
                }
                
                // set flip button over both if it is multifaced
                if let faces = multiFaced, faces.count > 1 {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    isFlipped.toggle()
                                }
                            } label: {
                                Image(systemName: "arrow.left.arrow.right.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .shadow(radius: 7)
                            }
                        }
                        Spacer()
                    }
                    .padding(4)
                }
            }
            .aspectRatio(0.714, contentMode: .fit)
            .cornerRadius(8)
            
            // show previews
            if showPreviews {
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
        }
        .padding(10)
    }
    
}

