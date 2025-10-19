//
//  SuggestionView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-18.
//

import SwiftUI

struct SuggestionView: View {
    
    var systemImage: String
    var title: String
    var description: String
    var collection: [CardJSON]
    
    // responsive grid
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // title
                    Label(title, systemImage: systemImage)
                        .font(.title2)
                        .bold()
                    
                    Text(description)
                        .foregroundColor(.gray)
                        .italic()
                        .lineLimit(1)
                    
                }
                .padding()
                
                
                // display cards in grid
                LazyVGrid(columns: columns) {
                    ForEach(collection) { card in
                        // pass a model version of the card to the views
                        let tempModel = SFAPI.JSONtoModel(json: card)
                        
                        SearchCardView(card: tempModel)
                    }
                }
            }
            
        }
    }
}

