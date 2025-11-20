//
//  SuggestionView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-18.
//  Purpose:
//         Displays the suggestion widgets with cards based off of hard coded filters. Meant as a discovery
//  External Types:
//         CardJSON, SFAPI, SearchCardView

// MARK: Imports

import SwiftUI

// MARK: Types

struct SuggestionView: View {
    
    // MARK: Stored Properties
    
    var systemImage: String
    var title: String
    var description: String
    var collection: [CardJSON]
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(description)
                        .foregroundColor(.gray)
                        .italic()
                        .lineLimit(1)
                }
                
                LazyVGrid(columns: columns) {
                    ForEach(collection) { card in
                        let tempModel = SFAPI.JSONtoModel(json: card)
                        SearchCardView(card: tempModel)
                    }
                }
            }
            .navigationTitle(title)
            .toolbarTitleDisplayMode(.large)
        }
    }
}

