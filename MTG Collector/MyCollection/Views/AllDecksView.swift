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
    
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 150), spacing: 30)]

    
    // state variables
    @State var newDeck: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(decks) { deck in
                        NavigationLink(destination: DeckView(deck: deck)) {
                            DeckGridWidget(deck: deck)
                                .padding(.bottom, 20)
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .listRowSpacing(60)
            .navigationTitle("My Decks")
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
