//
//  ManaCurveWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Mana curve for a deck's mainboard — a CMC histogram (0…6, then 7+), excluding lands.
//      Resolves card data via CardStore so it reflects the actual cards, not stored stats.
//  External Types:
//      Deck, Card, CardStore
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct ManaCurveWidget: View {

    // MARK: Stored Properties

    var deck: Deck
    /// Buckets 0…6 plus a final 7+ bucket.
    private let bucketCount = 8

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var buckets: [Int] = Array(repeating: 0, count: 8)

    private var maxCount: Int { max(buckets.max() ?? 0, 1) }

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mana Curve")
                .font(.headline)

            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<bucketCount, id: \.self) { i in
                    VStack(spacing: 4) {
                        Text("\(buckets[i])")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentColor.opacity(0.85))
                            .frame(height: barHeight(buckets[i]))
                        Text(i == bucketCount - 1 ? "\(i)+" : "\(i)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 120)
        }
        .padding()
        .frame(maxWidth: 600)
        .widgetStyle()
        .task(id: deck.mainboard.map { $0.scryfallCardID }) {
            await compute()
        }
    }

    // MARK: Helpers

    private func barHeight(_ count: Int) -> CGFloat {
        let maxBarHeight: CGFloat = 90
        return max(CGFloat(count) / CGFloat(maxCount) * maxBarHeight, count > 0 ? 4 : 0)
    }

    private func compute() async {
        var result = Array(repeating: 0, count: bucketCount)
        for entry in deck.mainboard where !entry.isDeleted {
            var card = CardStore.cached(entry.scryfallCardID, context: modelContext)
            if card == nil {
                card = await CardStore.resolve(entry.scryfallCardID, context: modelContext)
            }
            guard let card else { continue }
            // lands don't have a meaningful mana value on the curve
            if card.typeLine.contains("Land") { continue }
            let bucket = min(Int(card.cmc), bucketCount - 1)
            result[bucket] += entry.quantity
        }
        buckets = result
    }
}
