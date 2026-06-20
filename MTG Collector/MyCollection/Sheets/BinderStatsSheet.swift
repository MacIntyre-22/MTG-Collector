//
//  BinderStatsSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-10.
//  Purpose:
//      The full stats sheet for a single binder — renders the shared CollectionStatsContent from the
//      binder's stored CollectionStats. (The whole-collection "My Hold" view uses the same content
//      via WholeCollectionStatsSheet.)
//  External Types:
//      Binder, CollectionStatsContent, StatsUpdater, StatsStore
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct BinderStatsSheet: View {

    // MARK: Stored Properties

    var binder: Binder

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var stats: CollectionStats?

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                CollectionStatsContent(
                    stats: stats,
                    cardCount: binder.cardCount,
                    resources: .binder(binder)
                )
                .padding()
            }
            .navigationTitle("Statistics")
            .task {
                StatsUpdater.update(binder, context: modelContext)
                stats = StatsStore.stats(for: binder, context: modelContext)
            }
        }
    }
}
