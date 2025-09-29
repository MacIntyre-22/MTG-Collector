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
        ZStack(alignment: .bottomLeading) {
            
            // The main scrollable list
            List {
                Section("Display") {
                    VStack(spacing: 8) {
                        if let faces = card.cardFaces, !faces.isEmpty {
                            // create id by name or else error will be thrown
                            // not all the card faces have an id or are the same
                            
                            ForEach(faces, id: \.name) { face in
                                InfoDisplayWidget(name: face.name, typeLine: face.typeLine, colorIdentity: card.colorIdentity, oracleText: face.oracleText)
                                    .padding(.bottom, 10)
                            }
                        } else {
                            InfoDisplayWidget(typeLine: card.typeLine, colorIdentity: card.colorIdentity, oracleText: card.oracleText)
                        }
                    }
                }
                Section("Pricing") {
                    // Pricing info here
                    InfoPriceWidget(card: card)
                }
                Section("Legalities") {
                    // Legalities info here
                }
                Section("Information") {
                    // Additional info here
                }
            }
            .navigationTitle(card.name)
            .listRowSpacing(10)
            
            // Floating cards
            HStack(){
                Spacer()
                HStack(spacing: 8) {
                    if let faces = card.cardFaces, !faces.isEmpty {
                        // create id by name or else error will be thrown
                        // not all the card faces have an id or are the same
                        ForEach(faces, id: \.name) { face in
                            CardImageView(maxWidth: 75, imageUrl: face.imageURIs?.normal ?? "")
                        }
                    } else {
                        CardImageView(maxWidth: 100, imageUrl: card.imageURIs?.normal ?? "")
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

