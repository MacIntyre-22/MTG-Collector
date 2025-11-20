//
//  CardGridView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//  Purpose:
//      Displays a card model with some previews for that card
//  External Types:
//      Card, CardFace, CardimageView, GridRarityWidget, GridPriceWidget

// MARK: Imports

import SwiftUI

// MARK: Types

struct CardGridView: View {
    
    // MARK: Stored Properties

    var card: Card
    var showPreviews: Bool = false
    var isFoil: Bool = false
    var showNames: Bool = false
    var gradFoil: LinearGradient = LinearGradient(
                                        colors: [.blue, .purple, .pink, .orange, .yellow],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
    
    // MARK: State Properties

    @State private var isFlipped: Bool = false
    
    // MARK: Computed Properties
    
    var multiFaced: [CardFace]? {
        card.cardFaces
    }
    
    // MARK: View
    
    var body: some View {
        VStack{
            ZStack {
                /// if multifaced
                if let faces = multiFaced, faces.count > 1 {
                    /// Front face
                    ZStack {
                        CardImageView(maxWidth: 220, name: faces.first!.name, imageURIs: faces.first!.imageURIs)
                        if isFoil {
                            gradFoil.opacity(0.3)
                        }
                    }
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                    /// Back face
                    ZStack {
                        CardImageView(maxWidth: 220, name: faces.last!.name, imageURIs: faces.last!.imageURIs)
                        if isFoil {
                            gradFoil.opacity(0.3)
                        }
                    }
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                    
                } else {
                    /// Single faced card
                    ZStack {
                        CardImageView(maxWidth: 220, name: card.name, imageURIs: card.imageURIs)
                        if isFoil {
                            gradFoil.opacity(0.3)
                        }
                    }
                }
                
                /// set flip button over both faces if it is multifaced
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
            
            if showPreviews {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if !card.rarity.isEmpty {
                            GridRarityWidget(rarity: card.rarity)
                        }
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

