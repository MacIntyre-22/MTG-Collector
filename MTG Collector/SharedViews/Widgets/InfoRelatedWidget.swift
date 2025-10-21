//
//  InfoRelatedWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-02.
//

import SwiftUI

struct InfoRelatedWidget: View {
    // card part data
    var cardParts: [RelatedCardObject]
    
    // card objects grab from api using related card ids
    @State var relatedCards: [Card] = []
    
    // loads multiple times on appear so I set a check value
    @State private var isLoaded = false
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(relatedCards) { card in
                        CardGridView(card: card, showPreviews: true, isFoil: false)
                            .frame(maxWidth: 180)
                            .background(Color.gray.opacity(0.18))
                            .cornerRadius(10)
                    }
                }
                .frame(maxHeight: 275)
                
            }
            // only run once
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
                    .shadow(color: .gray.opacity(0.25), radius: 15, x: 0, y: 0)
            )
        }
        
    }
    
    
    // MARK: Get Card Parts
    // fetch card parts using their api
    func getCardParts() async {
        for card in cardParts {
            
            // fetch a card object by the id privided in card parts
            if let jsonPart = await SFAPI.fetchCardURI(uri: card.uri) {
                
                // make a model and add it to related cards array
                let modelPart = SFAPI.JSONtoModel(json: jsonPart)
                relatedCards.append(modelPart)
            }
            
        }
    }
}

