//
//  SearchCardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-10.
//  Purpose:
//      Displays a card from the search results and enables collection controlls
//  External Types:
//      Binder, Deck, CardInfoView, CardGridView, CollectionControlWidget

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct SearchCardView: View {
    
    // MARK: Stored Properties

    var card: Card
    
    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    
    // MARK: View

    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: CardInfoView(card: card)){
                CardGridView(card: card, showPreviews: true)
                    .background(content: {Color.gray.opacity(0.18)})
                    .cornerRadius(10)
            }
            /// controls
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

