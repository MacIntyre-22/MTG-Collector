//
//  DeckBuildSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct DeckBuildSheet: View {
    @Environment(\.modelContext) var modelContext
    var deck: Deck
    @State private var scryfallResults: [CardJSON] = []
    @State private var showFilters = false
    @State private var filters = CardFilters()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                // MARK: Grid View
                LazyVGrid(columns: [GridItem(.flexible(minimum: 200, maximum: 250)), GridItem(.flexible(minimum: 200, maximum: 250))]) {
                    ForEach(scryfallResults) { card in
                        VStack {
                            CardImageView(imageUrl: card.imageURIs?.normal ?? "https://c1.scryfall.com/file/scryfall-cards/back/neo/442.jpg")
                                
                            Text(card.name)
                                .lineLimit(1)
                            HStack {
                                Menu("Add") {
                                    Button("Mainboard") {
                                        addCard(card: card, board: 1)
                                    }
                                    Button("Sideboard") {
                                        addCard(card: card, board: 2)
                                    }
                                    Button("Maybeboard") {
                                        addCard(card: card, board: 3)
                                    }
                                }
                                
                            }
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
    
    func addCard(card: CardJSON, board: Int) {
        // create card model
        let newCard = SFAPI.JSONtoModel(card: card)
        
        // create entry then add to deck
        let entry = CardEntry(card: newCard)
        switch(board) {
            case 1:
                deck.mainboard.append(entry)
            case 2:
                deck.sideboard.append(entry)
            case 3:
                deck.maybeboard.append(entry)
            default:
                deck.mainboard.append(entry)
        }
    }
}

