//
//  AllDecksView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Displays all decks in a grid view
//  External Types:
//      Deck, DeckView, EditDeckSheet, DeckGridWidget, NewDeckSheet

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct AllDecksView: View {
    
    // MARK: Stored Properties
    
    let columns = [GridItem(.flexible(), spacing: 15),
                   GridItem(.flexible(), spacing: 15)]
    
    // MARK: State Properties
    
    @Environment(\.modelContext) var modelContext
    @Environment(ProAccessManager.self) private var pro
    @Query var decks: [Deck]
    @State var selectedDeck: Deck?
    @State var showAlert: Bool = false
    @State var newDeck: Bool = false
    @State var showPaywall: Bool = false

    /// Free tier allows up to 3 decks.
    private var canCreate: Bool { pro.isPro || decks.count < 3 }

    /// Pinned decks first, then most recently edited — a single sort pass.
    var sortedDecks: [Deck] {
        decks.sorted { a, b in
            a.pinned != b.pinned ? a.pinned : a.editedAt > b.editedAt
        }
    }
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(sortedDecks) { deck in
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
                        if canCreate { newDeck.toggle() } else { showPaywall = true }
                    }
                }
            })
            .sheet(isPresented: $newDeck) {
                NewDeckSheet()
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
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
    
    // MARK: deleteDeck
    func deleteDeck() {
        if let deck = selectedDeck {
            modelContext.delete(deck)
        }
    }
}
