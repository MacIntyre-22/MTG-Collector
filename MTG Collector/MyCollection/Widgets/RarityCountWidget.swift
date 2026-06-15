//
//  RarityCountWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Displays a collection's rarity breakdown (from CollectionStats.rarityBreakdown), with
//      each rarity colour-coded the way MTG players expect.

// MARK: Imports

import SwiftUI

// MARK: Types

struct RarityCountWidget: View {

    // MARK: Stored Properties

    var rarities: [String: Int]

    /// fixed display order
    private let order = ["common", "uncommon", "rare", "mythic"]

    private var sorted: [(rarity: String, count: Int)] {
        rarities
            .map { ($0.key, $0.value) }
            .sorted { a, b in
                (order.firstIndex(of: a.0) ?? 99) < (order.firstIndex(of: b.0) ?? 99)
            }
    }

    // MARK: View

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Rarities")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 15)
                ForEach(sorted, id: \.rarity) { item in
                    HStack {
                        Circle()
                            .fill(color(for: item.rarity))
                            .frame(width: 12, height: 12)
                        Text(item.rarity.capitalized)
                            .foregroundColor(.gray)
                            .italic()
                        Spacer()
                        Text("\(item.count)")
                            .bold()
                    }
                    .padding(10)
                }
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .padding(20)
            .widgetStyle()
        }
    }

    // MARK: Rarity colour

    private func color(for rarity: String) -> Color {
        switch rarity {
        case "common": return .black
        case "uncommon": return .gray
        case "rare": return .yellow
        case "mythic": return .orange
        default: return .blue
        }
    }
}
