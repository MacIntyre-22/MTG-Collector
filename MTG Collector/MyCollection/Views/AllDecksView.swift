//
//  AllDecksView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI
import SwiftData

struct AllDecksView: View {
    
    @Environment(\.modelContext) var modelContext
    // data
    @Query(sort: \Deck.editedAt, order: .reverse) var decks: [Deck]
    
    @State var selectedDeck: Deck?
    @State var showAlert: Bool = false
    
    var deckCount: Int {
        decks.count
    }
    
    let columns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 20),
                   GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 20)]
    
    // state variables
    @State var newDeck: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(decks.sorted(by: {$0.pinned && !$1.pinned})) { deck in
                        NavigationLink(destination: DeckView(deck: deck)) {
                            DeckGridWidget(deck: deck)
                                .contextMenu {
                                    NavigationLink(destination: EditDeckSheet(deck: deck)) {
                                        Text("Edit")
                                    }
                                    
                                    Button("Delete", role: .destructive) {
                                        selectedDeck = deck
                                        showAlert.toggle()
                                    }
                                }
                        }
                    }
                }
                .padding()
                
                
            }
            .padding(.horizontal, 10)
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
            .alert("Confirm", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {}
                
                Button("Delete", role: .destructive) {
                    deleteDeck()
                }
            } message: {
                Text("Delete this Deck?")
            }
        }
    }
    
    func deleteDeck() {
        let tempDeck: Deck? = selectedDeck.unsafelyUnwrapped
        
        if let deck = tempDeck{
            modelContext.delete(deck)
        }
    }
}

#Preview {
    AllDecksView()
}
