//
//  SearchTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI
import SwiftData

struct SearchTabView: View {
    // environment variables
    @Environment(\.modelContext) var modelContext
    // grab all binders
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    
    
    // Search Card Data
    @State var scryfallResults: [CardJSON] = []
    
    // Filters
    @State var showFilters = false
    @State var filters = CardFilters()
    
    // responsive grid
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // MARK: Grid View
                LazyVGrid(columns: columns) {
                    ForEach(scryfallResults) { card in
                        // pass a model version of the card to the views
                        let tempModel = SFAPI.JSONtoModel(json: card)
                        
                        SearchCardView(card: tempModel)
                    }
                }
            }
            .navigationTitle("Search")
            
            // MARK: Search Bar
            .searchable(text: $filters.text, prompt: "Search Cards")
            .keyboardType(.default)
            .onSubmit(of: .search, {
                Task {
                    let results = await SFAPI.fetchCardData(filters: filters)
                    scryfallResults = results
                }
                
            })
            // MARK: Filter btn and Sheet
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filters", systemImage: "slider.horizontal.3"){
                        showFilters.toggle()
                    }
                }
            })
            .sheet(isPresented: $showFilters) {
                FilterSheet(filters: $filters) {
                    Task {
                        let results = await SFAPI.fetchCardData(filters: filters)
                        scryfallResults = results
                    }
                }
            }
        }
    }
}
