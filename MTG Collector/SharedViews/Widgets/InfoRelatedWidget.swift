//
//  InfoRelatedWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-02.
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
    @State private var selectedCard: Card?
    
    // MARK: View

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(relatedCards) { card in
                        Button {
                            selectedCard = card
                        } label: {
                            CardGridView(card: card, showPreviews: true, finish: .nonfoil)
                                .frame(maxWidth: 180)
                                .background(Color.gray.opacity(0.18))
                                .cornerRadius(10)
                        }
                        .buttonStyle(.plain)
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
            .widgetStyle()
        }
        .cardInfoSheet(card: $selectedCard)
    }
    
    
    // MARK: getCardParts

    /// Resolve the related cards in a single batched request (`/cards/collection`) rather than one
    /// fetch per part — the old loop fired N rate-limited requests, so a card with many parts crawled.
    /// Capped defensively; the caller (CardInfoView) already hides generic-token dumps.
    func getCardParts() async {
        let ids = cardParts.prefix(20).map { CardIdentifierJSON(id: $0.id) }
        guard !ids.isEmpty else { return }
        let (found, _) = await SFAPI.fetchCardCollection(identifiers: ids)
        relatedCards = found.map(SFAPI.JSONtoModel)
    }
}

