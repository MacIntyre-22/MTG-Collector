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
    @Query var binders: [Binder]
    @Query var decks: [Deck]

    @State private var filters = FilterState()
    @State private var filteredEntries: [CardEntry] = []
    @State private var isFiltering = false
    @State private var showFilters = false
    @State private var showSettings = false

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
                            collectionButton(image: "MtgBinder", label: "Binders")
                        }
                        NavigationLink(destination: AllDecksView()) {
                            collectionButton(image: "MtgDeck", label: "Decks")
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    filterButton
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings", systemImage: "gearshape") {
                        showSettings = true
                    }
                }
            }
            .sheet(isPresented: $showFilters) {
                FilterSheetView(context: .collection, onApply: {
                    applyFilter()
                }, filters: $filters)
            }
            .sheet(isPresented: $showSettings) {
                if let general = generalBinder {
                    MyCollectionSettingsSheet(collection: general)
                }
            }
            .task {
                ensureGeneralCollection()
                refreshStats()
            }
        }
    }

    // MARK: Subviews

    private func collectionButton(image: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 60, height: 60)
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
            }
        } else {
            Button("Filter", systemImage: "line.3.horizontal.decrease.circle") {
                showFilters = true
            }
        }
    }

    /// Entries to display: filtered (engine output) when a filter is active, else newest first.
    private func displayedEntries(_ general: Binder) -> [CardEntry] {
        if isFiltering {
            return filteredEntries.filter { !$0.isDeleted }
        }
        return general.activeCards.sorted(by: { $0.dateAdded > $1.dateAdded })
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

    /// Create the permanent "My Hold" catch-all binder on first launch if it's missing,
    /// and normalise the name of any binder created under the old "General Collection" label.
    private func ensureGeneralCollection() {
        if let general = binders.first(where: { $0.isGeneral }) {
            if general.name == "General Collection" {
                general.name = "My Hold"
            }
        } else {
            let general = Binder(name: "My Hold", isGeneral: true)
            modelContext.insert(general)
        }
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
