//
//  SearchTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct SearchTabView: View {
    @State private var scryfallResults: [CardJSON] = []
    @State private var showFilters = false
    @State private var filters = CardFilters()
    
    // responsive grid
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // MARK: Grid View
                LazyVGrid(columns: columns) {
                        ForEach(scryfallResults) { card in
                            NavigationLink(destination: CardInfoView(card: card)){
                                CardGridView(card: card)
                            }
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
        }
    }
}

#Preview {
    SearchTabView()
}
