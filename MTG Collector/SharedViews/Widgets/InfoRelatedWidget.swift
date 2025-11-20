//
//  InfoRelatedWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-02.
//  Purpose:
//      Displays related cards using the RelatedCardObject
//  External Types:
//      RelatedCardObject, Card, CardinfoView, CardgridView, SFAPI

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoRelatedWidget: View {

    // MARK: Stored Properties

    var cardParts: [RelatedCardObject]
    
    // MARK: State Properties
    
    @State var relatedCards: [Card] = []
    @State private var isLoaded = false
    
    // MARK: View

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(relatedCards) { card in
                        NavigationLink(destination: CardInfoView(card: card)) {
                            CardGridView(card: card, showPreviews: true, isFoil: false)
                                .frame(maxWidth: 180)
                                .background(Color.gray.opacity(0.18))
                                .cornerRadius(10)
                        }
                    }
                }
                .frame(maxHeight: 275)
            }
            /// only run once
            .task {
                if !isLoaded {
                    await getCardParts()
                    isLoaded = true
                }
            }
            .padding(15)
            .cornerRadius(9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
    
    
    // MARK: getCardParts
    
    /// fetch card parts using api
    func getCardParts() async {
        for card in cardParts {
            /// fetch a card object by the id privided in card parts
            if let jsonPart = await SFAPI.fetchCardURI(uri: card.uri) {
                /// convert and add
                let modelPart = SFAPI.JSONtoModel(json: jsonPart)
                relatedCards.append(modelPart)
            }
            
        }
    }
}

