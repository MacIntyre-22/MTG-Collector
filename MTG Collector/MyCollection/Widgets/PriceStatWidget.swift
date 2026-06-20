//
//  PriceStatWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-23.
//  Purpose:
//      Displays the price of a collection in a widget style

// MARK: Imports

import SwiftUI

// MARK: Types

struct PriceStatWidget: View {
    
    // MARK: Stored Properties

    var stats: CollectionStats?

    @Environment(\.appCurrency) private var currency

    // MARK: View

    var body: some View {
        ZStack {
            VStack {
                Label("Cost", systemImage: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.gray)
                    .italic()
                Text(currency.formatCompact(currency.total(stats)))
                    .lineLimit(1)
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: 270, maxHeight: 100)
            .aspectRatio(1, contentMode: .fill)
            .padding(20)
            .widgetStyle()
        }
    }
}
