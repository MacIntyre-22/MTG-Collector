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
    
    @State var isSearching: Bool = false
    
    // responsive grid
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if isSearching {
                    // display no results
                    VStack(spacing: 16) {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding(.top, 100)
                } else {
                    // check for succesful search
                    if !scryfallResults.isEmpty {
                        // MARK: Grid View
                        LazyVGrid(columns: columns) {
                            ForEach(scryfallResults) { card in
                                // pass a model version of the card to the views
                                let tempModel = SFAPI.JSONtoModel(json: card)
                                
                                SearchCardView(card: tempModel)
                            }
                        }
                    } else {
                        // display no results
                        VStack(spacing: 16) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundStyle(.gray)
                            
                            Text("No results found")
                                .font(.title3.bold())
                                .foregroundStyle(.secondary)
                            
                            Text("Try changing your filters or search.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .padding(.top, 100)
                    }
                }
            }
            .navigationTitle("Search")
            
            // MARK: Search Bar
            .searchable(text: $filters.text, prompt: "Search Cards")
            .keyboardType(.default)
            .onSubmit(of: .search, {
                Task {
                    await search()
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
                        await search()
                    }
                }
            }
        }
    }
    
    func search() async {
        isSearching = true
        let results = await SFAPI.fetchCardData(filters: filters)
        scryfallResults = results
        isSearching = false
    }
}
