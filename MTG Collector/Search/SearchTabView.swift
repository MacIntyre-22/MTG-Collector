//
//  SearchTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//  Purpose:
//      Displays the tab to search cards from the api and add them to your collection
//  External Types:
//      Binder, Deck, CardJSON, CardFilters, SFAPI, SearchCardView, FilterSheet

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct SearchTabView: View {
    
    // MARK: Stored Properties

    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]
    
    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    @State var scryfallResults: [CardJSON] = []
    @State var showFilters = false
    @State var filters = CardFilters()
    @State var isSearching: Bool = false
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if isSearching {
                    VStack(spacing: 16) {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                    .padding(.top, 100)
                } else {
                    if !scryfallResults.isEmpty {
                        LazyVGrid(columns: columns) {
                            ForEach(scryfallResults) { card in
                                /// Json to model
                                let tempModel = SFAPI.JSONtoModel(json: card)
                                SearchCardView(card: tempModel)
                            }
                        }
                    } else {
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
            .searchable(text: $filters.text, prompt: "Search Cards")
            .keyboardType(.default)
            .onSubmit(of: .search, {
                Task {
                    await search()
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filters", systemImage: "slider.horizontal.3"){
                        showFilters.toggle()
                    }
                }
            })
            .sheet(isPresented: $showFilters) {
                FilterSheet(onSearch: {
                    Task {
                        await search()
                    }
                }, filters: $filters)
            }
        }
    }
    
    // MARK: search
    
    /// calls the search and sets the isSearching function to display the progressicon
    func search() async {
        isSearching = true
        let results = await SFAPI.fetchCardData(filters: filters)
        scryfallResults = results
        isSearching = false
    }
}
