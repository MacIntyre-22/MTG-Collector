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
    @Environment(\.dismiss) private var dismiss
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
    @State private var stats: CollectionStats?
    /// Transient "prices updated" banner shown after an on-open refresh.
    @State private var priceBanner: String?

    // MARK: Initializer

    init(deck: Deck) {
        self.deck = deck
        let custom = deck.coverUIImage
        self.coverImage = custom ?? UIImage(named: "CardholdIcon")!
        self.hasCover = custom != nil
    }

    // MARK: View

    var body: some View {
        CollectionScreen(
            coverImage: coverImage,
            hasCover: hasCover,
            showCover: deck.showCover,
            name: deck.name,
            stats: stats,
            count: deck.cardCount
        ) {
            VStack {
                ForEach(deck.activeLeaders) { leader in
                    CommanderWidget(
                        entry: leader,
                        label: DeckRules.slot(role: leader.role, ruleType: deck.ruleType)?.label ?? "Leader"
                    ) {
                        deck.removeLeader(leader)
                        DeckColors.refresh(deck, context: modelContext)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }

                switch selectedBoard {
                case 0: DeckBoardView(deck: deck, board: .main, selectedBoard: $selectedBoard, filters: filters, isFiltering: isFiltering, filterToken: filterToken)
                case 1: DeckBoardView(deck: deck, board: .side, selectedBoard: $selectedBoard, filters: filters, isFiltering: isFiltering, filterToken: filterToken)
                case 2: DeckBoardView(deck: deck, board: .maybe, selectedBoard: $selectedBoard, filters: filters, isFiltering: isFiltering, filterToken: filterToken)
                default: EmptyView()
                }
            }
        }
        .priceRefreshBanner($priceBanner)
        .task {
            StatsUpdater.update(deck, context: modelContext)
            stats = StatsStore.stats(for: deck, context: modelContext)
            // Seed colours for decks that have none yet (older decks / freshly imported).
            if deck.colorIdentity.isEmpty {
                DeckColors.refresh(deck, context: modelContext)
            }
            // Refresh any cards whose prices are stale, then update totals + notify.
            let ids = (deck.mainboard + deck.sideboard + deck.maybeboard).map(\.scryfallCardID)
            let refreshed = await PriceRefresher.refreshCollection(ids: ids, context: modelContext)
            if refreshed > 0 {
                StatsUpdater.update(deck, context: modelContext)
                stats = StatsStore.stats(for: deck, context: modelContext)
                priceBanner = "Prices updated · \(refreshed) card\(refreshed == 1 ? "" : "s")"
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                filterButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                CollectionShareMenu(target: .deck(deck))
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
                        .accessibilityLabel("More")
                }
            }
        }
        .sheet(isPresented: $showStats) {
            DeckStatsSheet(deck: deck)
        }
        .sheet(isPresented: $showEdit) {
            EditDeckSheet(deck: deck, onDelete: { deleteAndPop() })
        }
        .sheet(isPresented: $showNotes) {
            DeckNotesSheet(deck: deck)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
        .sheet(isPresented: $showFilters) {
            FilterSheetView(context: .deck, collectionTitle: "Deck", onApply: { applyFilter() }, filters: $filters)
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
                    .accessibilityLabel("Filter")
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

    /// Delete this deck and pop back to the list. Pops first, then deletes on the next runloop so the
    /// view stops rendering the deck before it's removed.
    private func deleteAndPop() {
        dismiss()
        let target = deck
        DispatchQueue.main.async {
            Spotlight.remove(kind: .deck, id: target.id)
            StatsStore.remove(for: target.id, context: modelContext)
            modelContext.delete(target)
        }
    }
}
