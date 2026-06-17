//
//  DeckView.swift
//  Cardhold
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
    @State var showPaywall: Bool = false
    @State var selectedBoard: Int = 0

    @State private var filters = FilterState()
    @State private var showFilters = false
    @State private var isFiltering = false
    /// Bumped on each Apply so each board re-runs the filter.
    @State private var filterToken = 0

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
                case 0: DeckBoardView(deck: deck, board: .main, filters: filters, isFiltering: isFiltering, filterToken: filterToken)
                case 1: DeckBoardView(deck: deck, board: .side, filters: filters, isFiltering: isFiltering, filterToken: filterToken)
                case 2: DeckBoardView(deck: deck, board: .maybe, filters: filters, isFiltering: isFiltering, filterToken: filterToken)
                default: EmptyView()
                }
            }
        }
        .task {
            StatsUpdater.update(deck, context: modelContext)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                filterButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
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
        .sheet(isPresented: $showFilters) {
            FilterSheetView(context: .collection, onApply: { applyFilter() }, filters: $filters)
        }
    }

    // MARK: Filtering

    /// Filter toolbar button — applies to every board; filled with an Edit/Clear menu when active.
    @ViewBuilder
    private var filterButton: some View {
        if isFiltering {
            Menu {
                Button("Edit Filter", systemImage: "slider.horizontal.3") { showFilters = true }
                Button("Clear Filter", systemImage: "xmark") {
                    isFiltering = false
                    filterToken += 1
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
            }
        } else {
            Button("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                showFilters = true
            }
        }
    }

    private func applyFilter() {
        isFiltering = true
        filterToken += 1
    }
}
