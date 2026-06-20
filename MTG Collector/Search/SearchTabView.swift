//
//  SearchTabView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      Displays the tab to search cards from the api and add them to your collection.
//      Uses the Phase 3 unified filter stack: a FilterState bound to FilterSheetView with the
//      Scryfall context. Results are paginated (Scryfall returns 175/page) via a Load More
//      button, with the total result count shown above the grid.
//  External Types:
//      CardJSON, FilterState, FilterSheetView, SFAPI, SearchCardView
//

// MARK: Imports

import SwiftUI
import SwiftData
import VisionKit

// MARK: Types

struct SearchTabView: View {

    // MARK: Stored Properties

    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Environment(AppRouter.self) private var router
    @Environment(ProAccessManager.self) private var pro
    @State private var showPaywall = false
    @State var filters = FilterState()
    @State var results: [CardJSON] = []
    @State var totalCards: Int = 0
    @State var nextPageURL: String? = nil
    @State var showFilters = false
    @State var isSearching = false
    @State var isLoadingMore = false
    @State var showScanner = false
    /// Drives the searchable field's active/focused state so deep links can open the keyboard.
    @State private var searchBarPresented = false
    /// false until the first search runs, so we can show a "start searching" state.
    @State var hasSearched = false

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView {
                if isSearching {
                    loadingState
                } else if !results.isEmpty {
                    resultsList
                } else if hasSearched {
                    emptyState(
                        icon: "magnifyingglass",
                        title: "No results found",
                        message: "Try changing your filters or search."
                    )
                } else {
                    emptyState(
                        icon: "magnifyingglass",
                        title: "Search for any Magic card",
                        message: "Search by name, or tap the filters to browse by colour, type, set and more."
                    ) {
                        if DataScannerViewController.isSupported {
                            PrimaryGlassButton(title: "Scan a Card", systemImage: "camera.viewfinder") {
                                openScanner()
                            }
                            .padding(.horizontal, 32)
                            .padding(.top, 8)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $filters.text, isPresented: $searchBarPresented, prompt: "Search Cards")
            .keyboardType(.default)
            .onSubmit(of: .search) {
                Task { await search() }
            }
            .toolbar {
                if DataScannerViewController.isSupported {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Scan", systemImage: "camera.viewfinder") {
                            openScanner()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterSheetView(context: .scryfall, onApply: {
                    Task { await search() }
                }, filters: $filters)
            }
            .fullScreenCover(isPresented: $showScanner) {
                CardScannerSheet()
            }
            .sheet(isPresented: $showPaywall) { PaywallView() }
            .onAppear { consumeRouterRequests() }
            .onChange(of: router.focusSearch) { _, _ in consumeRouterRequests() }
            .onChange(of: router.pendingScan) { _, _ in consumeRouterRequests() }
        }
    }

    // MARK: Deep linking

    /// Apply any pending request the router placed here (from a quick action, Siri shortcut or
    /// Spotlight): focus the search bar, or open the scanner. Each request is cleared once handled.
    private func consumeRouterRequests() {
        if router.focusSearch {
            router.focusSearch = false
            searchBarPresented = true
        }
        if router.pendingScan {
            router.pendingScan = false
            openScanner()
        }
    }

    /// Open the scanner, or the paywall if a free user has used today's scans. (Pro = unlimited.)
    private func openScanner() {
        guard DataScannerViewController.isSupported else { return }
        if !pro.isPro && ScanLimit.remainingToday() <= 0 {
            showPaywall = true
        } else {
            showScanner = true
        }
    }

    // MARK: Subviews

    /// Filter toolbar button — matches the collection tabs: an outline funnel that fills once any
    /// filter is set, with an Edit/Clear menu while active.
    @ViewBuilder
    private var filterButton: some View {
        if filters.hasActiveScryfallFilters {
            Menu {
                Button("Edit Filter", systemImage: "slider.horizontal.3") { showFilters = true }
                Button("Clear Filter", systemImage: "xmark") {
                    filters.resetFilters()
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

    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding(.top, 100)
    }

    private var resultsList: some View {
        VStack(spacing: 12) {
            HStack {
                Text("\(totalCards) \(totalCards == 1 ? "card" : "cards") found")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            .padding(.horizontal)

            LazyVGrid(columns: columns) {
                ForEach(results) { card in
                    let tempModel = SFAPI.JSONtoModel(json: card)
                    SearchCardView(card: tempModel)
                }
            }

            if nextPageURL != nil {
                Button {
                    Task { await loadMore() }
                } label: {
                    if isLoadingMore {
                        ProgressView()
                    } else {
                        Text("Load More")
                            .bold()
                    }
                }
                .padding(.vertical)
            }
        }
        .padding(.top, 8)
    }

    private func emptyState<Accessory: View>(
        icon: String,
        title: String,
        message: String,
        @ViewBuilder accessory: () -> Accessory = { EmptyView() }
    ) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.gray)

            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.secondary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            accessory()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
        .padding(.top, 100)
    }

    // MARK: Search

    /// Runs a fresh search (page 1) from the current filter state.
    func search() async {
        isSearching = true
        hasSearched = true
        let page = await SFAPI.fetchCardsPage(
            query: filters.scryfallQuery(),
            order: filters.sortBy.scryfallOrder,
            descending: filters.sortDescending
        )
        results = page.cards
        totalCards = page.totalCards
        nextPageURL = page.hasMore ? page.nextPage : nil
        isSearching = false
    }

    /// Appends the next page of results for the current query.
    func loadMore() async {
        guard let next = nextPageURL, !isLoadingMore else { return }
        isLoadingMore = true
        let page = await SFAPI.fetchCardsPage(nextPage: next)
        results.append(contentsOf: page.cards)
        totalCards = page.totalCards
        nextPageURL = page.hasMore ? page.nextPage : nil
        isLoadingMore = false
    }
}
