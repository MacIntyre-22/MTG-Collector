//
//  MyCollectionTabView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      The tab view for a user's collection. Shows a whole-collection summary, buttons through
//      to the Binders and Decks lists, and the permanent "My Hold" catch-all inline (a
//      Binder with isGeneral == true, auto-created on first launch). The catch-all's cards can
//      be filtered (CollectionFilterEngine) and configured via the settings sheet.
//  External Types:
//      Binder, Deck, CardEntry, FilterState, FilterSheetView, CollectionFilterEngine,
//      WholeCollectionStatsWidget, AllBindersView, AllDecksView, BinderCardView,
//      MyCollectionSettingsSheet, StatsUpdater
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct MyCollectionTabView: View {

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Environment(AppRouter.self) private var router
    @Environment(ProAccessManager.self) private var pro
    @Environment(\.appCurrency) private var currency
    @Query var binders: [Binder]
    @Query var decks: [Deck]

    @State private var filters = FilterState()
    @State private var filteredEntries: [CardEntry] = []
    /// Transient "prices updated" banner shown after an on-open refresh of the general collection.
    @State private var priceBanner: String?
    @State private var isFiltering = false
    @State private var showFilters = false
    @State private var showSettings = false
    @State private var showStats = false
    @State private var showPaywall = false
    @State private var showImport = false
    @State private var routedBinder: Binder?
    @State private var routedDeck: Deck?
    /// In-collection search by card name, plus the resolved cards it matches against.
    @State private var searchText = ""
    @State private var cardLookup: [String: Card] = [:]

    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]

    // MARK: Derived Data

    private var generalBinder: Binder? {
        binders.first(where: { $0.isGeneral })
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    WholeCollectionStatsWidget(binders: binders, decks: decks)
                        .padding(.horizontal, 10)

                    HStack(spacing: 15) {
                        NavigationLink(destination: AllBindersView()) {
                            collectionButton(systemImage: "folder.fill", label: "Binders")
                        }
                        NavigationLink(destination: AllDecksView()) {
                            collectionButton(systemImage: "rectangle.stack.fill", label: "Decks")
                        }
                    }
                    .padding(.horizontal, 10)

                    if let general = generalBinder {
                        generalSection(general)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("My Hold")
            .searchable(text: $searchText, prompt: "Search your cards")
            .navigationDestination(item: $routedBinder) { binder in
                BinderView(binder: binder)
            }
            .navigationDestination(item: $routedDeck) { deck in
                DeckView(deck: deck)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Import", systemImage: "square.and.arrow.down") {
                        pro.isPro ? (showImport = true) : (showPaywall = true)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Stats", systemImage: "chart.bar") {
                            pro.isPro ? (showStats = true) : (showPaywall = true)
                        }
                        Button("Settings", systemImage: "gearshape") { showSettings = true }
                    } label: {
                        Image(systemName: "ellipsis")
                            .accessibilityLabel("More")
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterSheetView(context: .collection, collectionTitle: "My Hold", onApply: {
                    applyFilter()
                }, filters: $filters)
            }
            .sheet(isPresented: $showStats) {
                WholeCollectionStatsSheet(binders: binders, decks: decks)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showSettings) {
                if let general = generalBinder {
                    MyCollectionSettingsSheet(collection: general)
                }
            }
            .sheet(isPresented: $showImport) {
                if let general = generalBinder {
                    ImportCardsSheet(target: .binder(general))
                }
            }
            .priceRefreshBanner($priceBanner)
            .task {
                ensureGeneralCollection()
                refreshStats()
                indexForSpotlight()
                QuickAction.refresh(binders: binders, decks: decks)
                if let general = generalBinder {
                    let ids = general.activeCards.map(\.scryfallCardID)
                    // Show cached cards instantly, then prime misses from the network and re-read.
                    cardLookup = CardStore.lookup(for: ids, context: modelContext)
                    await CardStore.prime(ids, context: modelContext)
                    cardLookup = CardStore.lookup(for: ids, context: modelContext)
                    // Refresh stale prices for the general collection, then update totals + notify.
                    let refreshed = await PriceRefresher.refreshCollection(ids: ids, context: modelContext)
                    if refreshed > 0 {
                        refreshStats()
                        priceBanner = "Prices updated · \(refreshed) card\(refreshed == 1 ? "" : "s")"
                    }
                }
            }
            .onAppear { consumeRouterRequests() }
            .onChange(of: router.pendingBinderID) { _, _ in consumeRouterRequests() }
            .onChange(of: router.pendingDeckID) { _, _ in consumeRouterRequests() }
        }
    }

    // MARK: Deep linking

    /// Push a binder or deck the router asked us to open (from Spotlight or a Siri shortcut),
    /// resolving the id against the live query. Each request is cleared once handled.
    private func consumeRouterRequests() {
        if let id = router.pendingBinderID {
            router.pendingBinderID = nil
            routedBinder = binders.first { $0.id == id && !$0.isDeleted }
        }
        if let id = router.pendingDeckID {
            router.pendingDeckID = nil
            routedDeck = decks.first { $0.id == id && !$0.isDeleted }
        }
    }

    // MARK: Subviews

    private func collectionButton(systemImage: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.primary)
            Text(label)
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 120)
        .widgetStyle()
    }

    @ViewBuilder
    private func generalSection(_ general: Binder) -> some View {
        let entries = displayedEntries(general)

        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cards")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "square.stack")
                    .foregroundStyle(.secondary)
                Text("\(general.cardCount)")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)

            if general.activeCards.isEmpty {
                Text("Add cards here without making a binder or deck.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else if entries.isEmpty {
                Text("No cards match your filters.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                LazyVGrid(columns: cardColumns) {
                    ForEach(entries) { entry in
                        BinderCardView(
                            entry: entry,
                            card: cardLookup[entry.scryfallCardID],
                            deleteEntry: {
                                general.cards.removeAll(where: { $0.id == entry.id })
                                StatsUpdater.update(general, context: modelContext)
                                if isFiltering { applyFilter() }
                            },
                            showPreviews: general.showPreviews,
                            showControls: general.showControls
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }

    // MARK: Filtering

    /// Filter toolbar button — filled with an Edit/Clear menu while a filter is active.
    @ViewBuilder
    private var filterButton: some View {
        if isFiltering {
            Menu {
                Button("Edit Filter", systemImage: "slider.horizontal.3") { showFilters = true }
                Button("Clear Filter", systemImage: "xmark") {
                    isFiltering = false
                    filteredEntries = []
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

    /// Entries to display: filtered (engine output) when a filter is active, else newest first,
    /// then narrowed by the search text (matched against resolved card names).
    private func displayedEntries(_ general: Binder) -> [CardEntry] {
        let base = isFiltering
            ? filteredEntries.filter { !$0.isDeleted }
            : general.activeCards.sorted(by: { $0.dateAdded > $1.dateAdded })
        guard !searchText.isEmpty else { return base }
        return base.filter { cardLookup[$0.scryfallCardID]?.name.localizedCaseInsensitiveContains(searchText) ?? false }
    }

    /// Run the collection filter engine over the catch-all's cards.
    private func applyFilter() {
        guard let general = generalBinder else { return }
        isFiltering = true
        let entries = general.activeCards
        Task {
            filteredEntries = await CollectionFilterEngine(entries: entries, context: modelContext)
                .apply(filters: filters)
        }
    }

    // MARK: Helpers

    /// Ensure the permanent "My Hold" catch-all exists (safety net — it's normally created at app
    /// launch in MTG_TabView). See `GeneralCollection.ensure`.
    private func ensureGeneralCollection() {
        GeneralCollection.ensure(context: modelContext)
    }

    /// Re-index every binder/deck (rich description + square cover) and favourite card into
    /// Spotlight. CoreSpotlight dedupes by identifier, so re-indexing is cheap.
    private func indexForSpotlight() {
        SpotlightIndexer.reindex(binders: binders, decks: decks, context: modelContext, currency: currency)
    }

    /// Keep stored stats current so the whole-collection summary is accurate.
    private func refreshStats() {
        for binder in binders {
            StatsUpdater.update(binder, context: modelContext)
        }
        for deck in decks {
            StatsUpdater.update(deck, context: modelContext)
        }
    }
}
