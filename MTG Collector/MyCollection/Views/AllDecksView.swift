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
    @Query var decks: [Deck]
    
    @State var selectedDeck: Deck?
    @State var showAlert: Bool = false
    
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
                .listRowSpacing(30)
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
