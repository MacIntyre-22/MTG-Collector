//
//  DeckView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Displays a deck's boards on the shared CollectionScreen scaffold (blurred cover
//      background + header). Adds the commander widget and a board picker; card cells, toolbar
//      and sheets are deck-specific.
//  External Types:
//      Deck, ImageManager, CollectionScreen, CommanderWidget, MainboardView, SideboardView, MaybeboardView, DeckStatsSheet, EditDeckSheet, DeckNotesSheet, StatsUpdater
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct DeckView: View {

    // MARK: Stored Properties

    var deck: Deck
    var coverImage: UIImage
    var hasCover: Bool

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Environment(ProAccessManager.self) private var pro
    @State var showEdit: Bool = false
    @State var showNotes: Bool = false
    @State var showStats: Bool = false
    @State var showSuggestions: Bool = false
    @State var showPaywall: Bool = false
    @State var selectedBoard: Int = 0

    // MARK: Initializer

    init(deck: Deck) {
        self.deck = deck
        let custom = ImageManager.fetchImage(withIdentifier: deck.id)
        self.coverImage = custom ?? UIImage(named: "MtgDeck")!
        self.hasCover = custom != nil
    }

    // MARK: View

    var body: some View {
        CollectionScreen(
            coverImage: coverImage,
            hasCover: hasCover,
            showCover: deck.showCover,
            name: deck.name,
            stats: deck.stats,
            count: deck.cardCount
        ) {
            VStack {
                Picker("Boards", selection: $selectedBoard) {
                    Text("Main").tag(0)
                    Text("Side").tag(1)
                    Text("Maybe").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if let commander = deck.commander {
                    CommanderWidget(entry: commander) {
                        deck.commander = nil
                    }
                    .padding()
                }

                switch selectedBoard {
                case 0: DeckBoardView(deck: deck, board: .main)
                case 1: DeckBoardView(deck: deck, board: .side)
                case 2: DeckBoardView(deck: deck, board: .maybe)
                default: EmptyView()
                }
            }
        }
        .task {
            StatsUpdater.update(deck, context: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Suggestions", systemImage: "wand.and.stars") {
                        pro.isPro ? showSuggestions.toggle() : (showPaywall = true)
                    }
                    Button("Stats", systemImage: "chart.bar") {
                        pro.isPro ? showStats.toggle() : (showPaywall = true)
                    }
                    Button("Notes", systemImage: "note.text") { showNotes.toggle() }
                    Button("Settings", systemImage: "gearshape") { showEdit.toggle() }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .sheet(isPresented: $showSuggestions) {
            DeckSuggestionsView(deck: deck)
        }
        .sheet(isPresented: $showStats) {
            DeckStatsSheet(deck: deck)
        }
        .sheet(isPresented: $showEdit) {
            EditDeckSheet(deck: deck)
        }
        .sheet(isPresented: $showNotes) {
            DeckNotesSheet(deck: deck)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}
