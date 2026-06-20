//
//  WholeCollectionStatsWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Top-of-tab summary of everything the user owns: total value, total cards, unique cards,
//      and a colour breakdown. Aggregates the stored CollectionStats from every binder and deck
//      (StatsUpdater keeps those current), so no card data is re-resolved here. The full per-binder
//      detail lives in BinderStatsSheet (opened from the My Hold ⋯ menu).
//  External Types:
//      Binder, Deck, Collection, CollectionStats
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct WholeCollectionStatsWidget: View {

    // MARK: Stored Properties

    var binders: [Binder]
    var decks: [Deck]

    @Environment(\.appCurrency) private var currency
    @Environment(ProAccessManager.self) private var pro
    /// Reactive — the summary re-renders whenever any collection's local stats change.
    @Query private var allStats: [CollectionStats]
    @State private var showStats = false
    @State private var showPaywall = false
    private let allColors = ["W", "U", "B", "R", "G"]

    // MARK: Aggregates

    private var collections: [Collection] {
        binders.map { $0 as Collection } + decks.map { $0 as Collection }
    }

    /// Aggregated totals across every collection's local stats, built in a single pass (one fetch).
    private struct Summary {
        var totalCards = 0
        var uniqueCards = 0
        var totalValue = 0.0
        var colourBreakdown: [String: Int] = [:]
    }

    private var summary: Summary {
        let byID = Dictionary(allStats.map { ($0.collectionID, $0) }, uniquingKeysWith: { first, _ in first })

        var s = Summary()
        for collection in collections where collection.inCollection {
            guard let stats = byID[collection.id] else { continue }
            s.totalCards += stats.totalCards
            s.uniqueCards += stats.uniqueCards
            s.totalValue += currency.total(stats)
            for (colour, count) in stats.colourBreakdown {
                s.colourBreakdown[colour, default: 0] += count
            }
        }
        return s
    }

    // MARK: View

    var body: some View {
        let s = summary
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                statBlock(value: currency.formatCompact(s.totalValue), label: "Value")
                Spacer()
                statBlock(value: "\(s.totalCards)", label: "Cards")
                Spacer()
                statBlock(value: "\(s.uniqueCards)", label: "Unique")
            }

            if !s.colourBreakdown.isEmpty {
                Divider()
                HStack(spacing: 14) {
                    ForEach(allColors, id: \.self) { colour in
                        if let count = s.colourBreakdown[colour], count > 0 {
                            HStack(spacing: 4) {
                                OracleSymbolImage(symbol: "{\(colour)}", size: 20)
                                Text("\(count)")
                                    .font(.subheadline)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .frame(maxWidth: 600)
        .widgetStyle()
        // Tap the summary to open the full whole-collection stats sheet (Pro-gated, like the ⋯ menu).
        .contentShape(Rectangle())
        .onTapGesture {
            pro.isPro ? (showStats = true) : (showPaywall = true)
        }
        .sheet(isPresented: $showStats) {
            WholeCollectionStatsSheet(binders: binders, decks: decks)
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }

    // MARK: Helpers

    private func statBlock(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
