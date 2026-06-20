//
//  WholeCollectionStatsSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The "My Hold" stats sheet — the same layout as a binder's, but over the *whole* collection:
//      an aggregate of every in-collection binder and deck (collections excluded in their settings
//      are left out). A disclaimer at the top explains the scope.
//  External Types:
//      Binder, Deck, CollectionStats, CollectionStatsContent, StatsStore, StatsUpdater
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Sheet

struct WholeCollectionStatsSheet: View {

    var binders: [Binder]
    var decks: [Deck]

    @Environment(\.modelContext) private var modelContext
    @State private var stats: CollectionStats?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                CollectionStatsContent(
                    stats: stats,
                    cardCount: stats?.totalCards ?? 0,
                    disclaimer: "Totals cover all your binders and decks, except any you've excluded in that collection's settings."
                )
                .padding()
            }
            .navigationTitle("Statistics")
            .task {
                // Make sure each collection's stats are current, then aggregate them.
                for binder in binders where !binder.isDeleted { StatsUpdater.update(binder, context: modelContext) }
                for deck in decks where !deck.isDeleted { StatsUpdater.update(deck, context: modelContext) }
                stats = StatsAggregator.wholeCollection(binders: binders, decks: decks, context: modelContext)
            }
        }
    }
}

// MARK: Aggregator

@MainActor
enum StatsAggregator {

    /// Build a transient CollectionStats summing every in-collection binder/deck. Values are stored
    /// canonically (USD price, raw counts), so the display layer converts as usual.
    static func wholeCollection(binders: [Binder], decks: [Deck], context: ModelContext) -> CollectionStats {
        func merge(_ into: inout [String: Int], _ from: [String: Int]) {
            for (key, count) in from { into[key, default: 0] += count }
        }

        let collections: [Collection] = binders.map { $0 as Collection } + decks.map { $0 as Collection }
        let agg = CollectionStats()
        var manaSum = 0.0

        for collection in collections where collection.inCollection && !collection.isDeleted {
            guard let s = StatsStore.stats(for: collection.id, context: context) else { continue }
            agg.totalCards += s.totalCards
            agg.uniqueCards += s.uniqueCards
            agg.totalPriceUSD += s.totalPriceUSD
            agg.landCount += s.landCount
            manaSum += s.avgManaCost * Double(s.manaCount)
            agg.manaCount += s.manaCount
            merge(&agg.rarityBreakdown, s.rarityBreakdown)
            merge(&agg.colourBreakdown, s.colourBreakdown)
            merge(&agg.typeBreakdown, s.typeBreakdown)
            merge(&agg.setBreakdown, s.setBreakdown)
            merge(&agg.finishBreakdown, s.finishBreakdown)
            if s.highestPricedCardValue > agg.highestPricedCardValue {
                agg.highestPricedCardValue = s.highestPricedCardValue
                agg.highestPricedCardID = s.highestPricedCardID
            }
        }
        agg.avgManaCost = agg.manaCount > 0 ? manaSum / Double(agg.manaCount) : 0
        return agg
    }
}
