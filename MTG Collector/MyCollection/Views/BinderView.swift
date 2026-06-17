//
//  BinderView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Displays a binder's cards on the shared CollectionScreen scaffold (blurred cover
//      background + header). Card cells, toolbar and sheets are binder-specific.
//  External Types:
//      Binder, ImageManager, CollectionScreen, BinderCardView, BinderStatsSheet, EditBinderSheet, BinderNotesSheet, StatsUpdater
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct BinderView: View {

    // MARK: Stored Properties

    var binder: Binder
    var coverImage: UIImage
    var hasCover: Bool
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Environment(ProAccessManager.self) private var pro
    @State var showNotes: Bool = false
    @State var showEdit: Bool = false
    @State var showStats: Bool = false
    @State var showPaywall: Bool = false

    @State private var filters = FilterState()
    @State private var showFilters = false
    @State private var isFiltering = false
    @State private var filteredEntries: [CardEntry] = []

    // MARK: Initializer

    init(binder: Binder) {
        self.binder = binder
        let custom = ImageManager.fetchImage(withIdentifier: binder.id)
        self.coverImage = custom ?? UIImage(named: "MtgBinder")!
        self.hasCover = custom != nil
    }

    // MARK: View

    var body: some View {
        CollectionScreen(
            coverImage: coverImage,
            hasCover: hasCover,
            showCover: binder.showCover,
            name: binder.name,
            stats: binder.stats,
            count: binder.cardCount
        ) {
            LazyVGrid(columns: cardColumns) {
                ForEach(displayedEntries) { entry in
                    BinderCardView(
                        entry: entry,
                        deleteEntry: {
                            binder.cards.removeAll(where: { $0.id == entry.id })
                            StatsUpdater.update(binder, context: modelContext)
                            if isFiltering { applyFilter() }
                        },
                        showPreviews: binder.showPreviews,
                        showControls: binder.showControls
                    )
                }
            }
        }
        .task {
            StatsUpdater.update(binder, context: modelContext)
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
            BinderStatsSheet(binder: binder)
        }
        .sheet(isPresented: $showEdit) {
            EditBinderSheet(binder: binder)
        }
        .sheet(isPresented: $showNotes) {
            BinderNotesSheet(binder: binder)
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

    private var displayedEntries: [CardEntry] {
        if isFiltering {
            return filteredEntries.filter { !$0.isDeleted }
        }
        return binder.cards.filter { !$0.isDeleted }.sorted { $0.dateAdded > $1.dateAdded }
    }

    private func applyFilter() {
        isFiltering = true
        let entries = binder.cards.filter { !$0.isDeleted }
        Task {
            filteredEntries = await CollectionFilterEngine(entries: entries, context: modelContext)
                .apply(filters: filters)
        }
    }
}
