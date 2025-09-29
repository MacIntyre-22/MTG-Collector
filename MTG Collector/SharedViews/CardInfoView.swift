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
                    InfoDisplayWidget(card: card)
                }
                Section("Pricing") {
                    // Pricing info here
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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    if let faces = card.cardFaces, !faces.isEmpty {
                        ForEach(faces) { face in
                            CardImageView(maxWidth: 75, imageUrl: face.imageURIs?.normal ?? "")
                        }
                    } else {
                        CardImageView(maxWidth: 100, imageUrl: card.imageURIs?.normal ?? "")
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                
            }
            .frame(height: 150)
            .padding()
            .shadow(radius: 4)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                CollectionControllWidget(card: card)
            }
        })
    }
    
}

