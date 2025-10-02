//
//  CardInfoView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardInfoView: View {
    // data
    var card: Card
    
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            // The main scrollable list
            List {
                Section("Information") {
                    VStack(spacing: 8) {
                        if !card.cardFaces.isEmpty {
                            
                            ForEach(card.cardFaces) { face in
                                InfoDisplayWidget(name: face.name, typeLine: face.typeLine, colorIdentity: card.colorIdentity, oracleText: face.oracleText)
                                    .padding(.bottom, 10)
                            }
                        } else {
                            InfoDisplayWidget(typeLine: card.typeLine, colorIdentity: card.colorIdentity, oracleText: card.oracleText)
                        }
                    }
                }
                
                Section("Pricing") {
                    // pricing info
                    InfoPriceWidget(prices: card.prices)
                }
                
                Section("Legalities") {
                    // Legalities info here
                    InfoLegalWidget(legalities: card.legalities)
                }
                
                Section("Other") {
                    // Additional info here
                }
            }
            .navigationTitle(card.name)
            .listRowSpacing(10)
            
            // Floating cards
            HStack(){
                Spacer()
                HStack(spacing: 8) {
                    if !card.cardFaces.isEmpty {
                        ForEach(card.cardFaces) { face in
                            CardImageView(maxWidth: 75, imageUrl: face.imageURIs.normal)
                        }
                    } else {
                        CardImageView(maxWidth: 100, imageUrl: card.imageURIs.normal)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                
                .shadow(radius: 4)
            }
            .frame(height: 150)
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                CollectionControllWidget(card: card)
            }
        })
    }
    
}

