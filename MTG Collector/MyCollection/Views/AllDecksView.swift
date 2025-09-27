//
//  AllDecksView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI
import SwiftData

struct AllDecksView: View {
    // data
    @Query var decks: [Deck]
    
    var deckCount: Int {
        decks.count
    }
    
    // state variables
    @State var newDeck: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Info") {
                    
                }
                
                Section("My Decks") {
                    ForEach(decks) { deck in
                        NavigationLink(destination: DeckView(deck: deck)) {
                            DeckGridWidget(deck: deck)
                        }
                    }
                }
            }
            .listRowSpacing(10)
            .navigationTitle("Decks")
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("New", systemImage: "plus"){
                        newDeck.toggle()
                    }
                }
            })
            .sheet(isPresented: $newDeck) {
                NewDeckSheet()
            }
        }
    }
}

#Preview {
    AllDecksView()
}
