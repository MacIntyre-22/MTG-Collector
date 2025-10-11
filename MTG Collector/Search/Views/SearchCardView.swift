//
//  SearchCardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-10.
//

import SwiftUI
import SwiftData

struct SearchCardView: View {
    // environment variables
    @Environment(\.modelContext) var modelContext
    // grab all binders
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    
    
    var card: Card
    
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: CardInfoView(card: card)){
                
                
                CardGridView(card: card, showPreviews: true)
                // adding styling here makes card grid view more modular
                    .background(content: {Color.gray.opacity(0.18)})
                    .cornerRadius(10)
            }
            
            // controls
            HStack {
                Menu {
                    CollectionControllWidget(card: card)
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.accentColor)
                        .cornerRadius(5)
                        .bold()
                        .shadow(radius: 4)
                }
                .padding(5)
                
            }
            .padding(.top, 30)
        }
    }
}

