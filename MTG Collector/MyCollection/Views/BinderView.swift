//
//  BinderView.swift
//  Cardhold
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
    @Environment(\.dismiss) private var dismiss
    @State var showNotes: Bool = false
    @State var showEdit: Bool = false
    @State var showStats: Bool = false
    @State var showPaywall: Bool = false

    @State private var filters = FilterState()
    @State private var showFilters = false
    @State private var isFiltering = false
    @State private var filteredEntries: [CardEntry] = []
    @State private var stats: CollectionStats?
    /// Transient "prices updated" banner shown after an on-open refresh.
    @State private var priceBanner: String?

    // MARK: Initializer

    init(binder: Binder) {
        self.binder = binder
        let custom = binder.coverUIImage
        self.coverImage = custom ?? UIImage(named: "CardholdIcon")!
        self.hasCover = custom != nil
    }

    // MARK: View

    var body: some View {
        CollectionScreen(
            coverImage: coverImage,
            hasCover: hasCover,
            showCover: binder.showCover,
            name: binder.name,
            stats: stats,
            count: binder.cardCount
        ) {
            if !hasCards {
                emptyState("No cards in this binder yet. Add some from Search or the scanner.")
            } else if displayedEntries.isEmpty {
                emptyState("No cards match your filters.")
            } else {
                LazyVGrid(columns: cardColumns) {
                    ForEach(displayedEntries) { entry in
                        BinderCardView(
                            entry: entry,
                            deleteEntry: {
                                binder.cards.removeAll(where: { $0.id == entry.id })
                                StatsUpdater.update(binder, context: modelContext)
                                stats = StatsStore.stats(for: binder, context: modelContext)
                                if isFiltering { applyFilter() }
                            },
                            showPreviews: binder.showPreviews,
                            showControls: binder.showControls
                        )
                    }
                }
            }
        }
        .priceRefreshBanner($priceBanner)
        .task {
            let ids = binder.cards.map(\.scryfallCardID)
            await CardStore.prime(ids, context: modelContext)
            StatsUpdater.update(binder, context: modelContext)
            stats = StatsStore.stats(for: binder, context: modelContext)
            // Refresh any cards whose prices are stale, then update totals + notify.
            let refreshed = await PriceRefresher.refreshCollection(ids: ids, context: modelContext)
            if refreshed > 0 {
                StatsUpdater.update(binder, context: modelContext)
                stats = StatsStore.stats(for: binder, context: modelContext)
                priceBanner = "Prices updated · \(refreshed) card\(refreshed == 1 ? "" : "s")"
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                filterButton
            }
            ToolbarItem(placement: .topBarTrailing) {
                CollectionShareMenu(target: .binder(binder))
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
            BinderStatsSheet(binder: binder)
        }
        .sheet(isPresented: $showEdit) {
            EditBinderSheet(binder: binder, onDelete: { deleteAndPop() })
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
                    .accessibilityLabel("Filter")
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

    /// Whether the binder holds any (non-deleted) cards at all — distinguishes "empty binder" from
    /// "filter hid everything".
    private var hasCards: Bool {
        binder.cards.contains { !$0.isDeleted }
    }

    private func emptyState(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
    }

    private func applyFilter() {
        isFiltering = true
        let entries = binder.cards.filter { !$0.isDeleted }
        Task {
            filteredEntries = await CollectionFilterEngine(entries: entries, context: modelContext)
                .apply(filters: filters)
        }
    }

    /// Delete this binder and pop back to the list. Pops first, then deletes on the next runloop so
    /// the view stops rendering the binder before it's removed.
    private func deleteAndPop() {
        dismiss()
        let target = binder
        DispatchQueue.main.async {
            Spotlight.remove(kind: .binder, id: target.id)
            StatsStore.remove(for: target.id, context: modelContext)
            modelContext.delete(target)
        }
    }
}
