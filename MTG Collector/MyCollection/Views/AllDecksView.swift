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
    @State var newDeck: Bool = false
    @State var showPaywall: Bool = false
    /// Context-menu actions, presented as sheets owned here (so they work from a long-press).
    @State private var statsDeck: Deck?
    @State private var notesDeck: Deck?
    @State private var editDeck: Deck?

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
            Group {
                if sortedDecks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "rectangle.stack")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("No Decks")
                            .font(.title2.bold())
                        Text("Build a deck to track its cards, mana curve and format legality.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                        PrimaryGlassButton(title: "New Deck", systemImage: "plus") {
                            if canCreate { newDeck.toggle() } else { showPaywall = true }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(sortedDecks) { deck in
                                NavigationLink(destination: DeckView(deck: deck)) {
                                    DeckGridWidget(deck: deck)
                                        .contextMenu {
                                            // Mirrors the deck screen's toolbar (minus filter).
                                            CollectionShareMenu(target: .deck(deck), compact: false)
                                            Button("Stats", systemImage: "chart.bar") {
                                                if pro.isPro { statsDeck = deck } else { showPaywall = true }
                                            }
                                            Button("Notes", systemImage: "note.text") { notesDeck = deck }
                                            Button("Settings", systemImage: "gearshape") { editDeck = deck }
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.horizontal, 10)
                }
            }
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
            .sheet(item: $statsDeck) { deck in
                DeckStatsSheet(deck: deck)
            }
            .sheet(item: $notesDeck) { deck in
                DeckNotesSheet(deck: deck)
                    .presentationDetents([.medium, .large])
            }
            .sheet(item: $editDeck) { deck in
                EditDeckSheet(deck: deck, onDelete: { deleteDeck(deck) })
            }
        }
    }

    // MARK: deleteDeck
    func deleteDeck(_ deck: Deck) {
        Spotlight.remove(kind: .deck, id: deck.id)
        StatsStore.remove(for: deck.id, context: modelContext)
        modelContext.delete(deck)
    }
}
