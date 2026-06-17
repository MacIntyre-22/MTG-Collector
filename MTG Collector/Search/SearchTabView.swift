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
    @State var filters = FilterState()
    @State var results: [CardJSON] = []
    @State var totalCards: Int = 0
    @State var nextPageURL: String? = nil
    @State var showFilters = false
    @State var isSearching = false
    @State var isLoadingMore = false
    @State var showScanner = false
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
                    )
                }
            }
            .navigationTitle("Search")
            .searchable(text: $filters.text, prompt: "Search Cards")
            .keyboardType(.default)
            .onSubmit(of: .search) {
                Task { await search() }
            }
            .toolbar {
                if DataScannerViewController.isSupported {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Scan", systemImage: "camera.viewfinder") {
                            showScanner = true
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Filters", systemImage: "slider.horizontal.3") {
                        showFilters.toggle()
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterSheetView(context: .scryfall, onApply: {
                    Task { await search() }
                }, filters: $filters)
            }
            .fullScreenCover(isPresented: $showScanner) {
                CardScannerSheet(onSearch: { name in
                    filters.text = name
                    showScanner = false
                    Task { await search() }
                })
            }
        }
    }

    // MARK: Subviews

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

    private func emptyState(icon: String, title: String, message: String) -> some View {
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
