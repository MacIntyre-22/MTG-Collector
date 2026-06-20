//
//  CollectionStatsContent.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The shared stats layout used by both the per-binder sheet and the whole-collection ("My Hold")
//      sheet. Renders headline numbers, the dearest card, and the rarity / colour / type / set /
//      finish breakdowns from a CollectionStats value (real for a binder, or an aggregate for the
//      whole collection). An optional disclaimer note and external-resources section sit at the
//      edges depending on the caller.
//  External Types:
//      CollectionStats, StatWidget, PriceStatWidget, HighCardWidget, ManaCountWidget, TypeCountWidget,
//      BreakdownListWidget, ExternalResourcesWidget, ExternalResourcesContext, CardFinish
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct CollectionStatsContent: View {

    // MARK: Stored Properties

    let stats: CollectionStats?
    let cardCount: Int
    /// Shown as a note above the stats (used by the whole-collection sheet).
    var disclaimer: String? = nil
    /// Outbound links section; omitted for the whole collection.
    var resources: ExternalResourcesContext? = nil

    private let rarityOrder = ["common", "uncommon", "rare", "mythic", "special", "bonus"]

    // MARK: View

    var body: some View {
        VStack(spacing: 14) {
            if let disclaimer {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle")
                    Text(disclaimer)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .widgetStyle()
            }

            // Headline numbers
            HStack(spacing: 14) {
                StatWidget(text: "\(cardCount)", label: Label("Cards", systemImage: "square.stack"))
                PriceStatWidget(stats: stats)
            }
            HStack(spacing: 14) {
                StatWidget(text: "\(stats?.uniqueCards ?? 0)",
                           label: Label("Unique", systemImage: "rectangle.on.rectangle"))
                StatWidget(text: String(format: "%.2f", stats?.avgManaCost ?? 0),
                           label: Label("Avg MV", systemImage: "drop"))
            }
            HStack(spacing: 14) {
                StatWidget(text: "\(stats?.landCount ?? 0)", label: Label("Lands", systemImage: "mountain.2"))
                StatWidget(text: "\(stats?.setBreakdown.count ?? 0)", label: Label("Sets", systemImage: "square.grid.2x2"))
            }

            if let highest = stats?.highestPricedCardID, !highest.isEmpty {
                HighCardWidget(cardID: highest)
            }

            if let colour = stats?.colourBreakdown, !colour.isEmpty {
                ManaCountWidget(manaTypeCount: colour)
            }
            if !rarityItems.isEmpty {
                BreakdownListWidget(title: "Rarity", items: rarityItems)
            }
            if let type = stats?.typeBreakdown, !type.isEmpty {
                TypeCountWidget(cardTypeCount: type)
            }
            if !setItems.isEmpty {
                BreakdownListWidget(title: "Sets", items: setItems)
            }
            if !finishItems.isEmpty {
                BreakdownListWidget(title: "Finish", items: finishItems)
            }

            if let resources {
                ExternalResourcesWidget(context: resources)
            }
        }
    }

    // MARK: Ordered breakdowns

    private var rarityItems: [(label: String, count: Int)] {
        guard let r = stats?.rarityBreakdown else { return [] }
        return rarityOrder.compactMap { key in r[key].map { (label: key.capitalized, count: $0) } }
    }

    private var setItems: [(label: String, count: Int)] {
        guard let s = stats?.setBreakdown else { return [] }
        return s.sorted { $0.value > $1.value }.prefix(12).map { (label: $0.key, count: $0.value) }
    }

    private var finishItems: [(label: String, count: Int)] {
        guard let f = stats?.finishBreakdown else { return [] }
        return CardFinish.allCases.compactMap { fin in f[fin.rawValue].map { (label: fin.label, count: $0) } }
    }
}
