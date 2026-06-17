//
//  WholeCollectionStatsWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Top-of-tab summary of everything the user owns: total value, total cards, unique cards,
//      and a colour breakdown. Aggregates the stored CollectionStats from every binder and deck
//      (StatsUpdater keeps those current), so no card data is re-resolved here.
//  External Types:
//      Binder, Deck, Collection, CollectionStats
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct WholeCollectionStatsWidget: View {

    // MARK: Stored Properties

    var binders: [Binder]
    var decks: [Deck]

    @Environment(\.appCurrency) private var currency
    private let allColors = ["W", "U", "B", "R", "G"]

    // MARK: Aggregates

    private var collections: [Collection] {
        binders.map { $0 as Collection } + decks.map { $0 as Collection }
    }

    private var totalCards: Int {
        collections.reduce(0) { $0 + ($1.stats?.totalCards ?? 0) }
    }

    private var uniqueCards: Int {
        collections.reduce(0) { $0 + ($1.stats?.uniqueCards ?? 0) }
    }

    private var totalValue: Double {
        collections.reduce(0) { $0 + currency.total($1.stats) }
    }

    private var colourBreakdown: [String: Int] {
        var merged: [String: Int] = [:]
        for collection in collections {
            for (colour, count) in (collection.stats?.colourBreakdown ?? [:]) {
                merged[colour, default: 0] += count
            }
        }
        return merged
    }

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                statBlock(value: currency.format(totalValue), label: "Value")
                Spacer()
                statBlock(value: "\(totalCards)", label: "Cards")
                Spacer()
                statBlock(value: "\(uniqueCards)", label: "Unique")
            }

            if !colourBreakdown.isEmpty {
                Divider()
                HStack(spacing: 14) {
                    ForEach(allColors, id: \.self) { colour in
                        if let count = colourBreakdown[colour], count > 0 {
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
