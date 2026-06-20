//
//  BoardTotalsWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      A deck's three boards (mainboard / sideboard / maybeboard) listed together, each row pairing
//      its card count with its total value — so the per-board totals read at a glance instead of
//      being scattered across single-stat tiles. Pre-formatted by the stats sheet (prices already in
//      the display currency); this is pure layout.
//  External Types:
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct BoardTotalsWidget: View {

    // MARK: Stored Properties

    /// One row per board, with the card count and the already-formatted price.
    let rows: [(label: String, cards: Int, price: String)]

    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            Text("Boards")
                .font(.title3)
                .bold()
                .padding(.bottom, 12)

            ForEach(rows, id: \.label) { row in
                HStack {
                    Text(row.label)
                        .foregroundColor(.gray)
                        .italic()
                        .lineLimit(1)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "square.stack")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text("\(row.cards)")
                            .bold()
                    }
                    Text(row.price)
                        .bold()
                        .frame(minWidth: 70, alignment: .trailing)
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 10)
            }
        }
        .frame(maxWidth: 600)
        .frame(minHeight: 60)
        .padding(20)
        .widgetStyle()
    }
}
