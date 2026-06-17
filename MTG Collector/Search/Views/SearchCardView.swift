//
//  SearchCardView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-10.
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
    @Environment(\.appTint) private var tint
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    
    // MARK: View

    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: CardInfoView(card: card)){
                CardGridView(card: card, showPreviews: true)
                    .widgetStyle(.solid)
            }
            /// controls
            HStack {
                Menu {
                    CollectionControllWidget(card: card)
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(tint)
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

