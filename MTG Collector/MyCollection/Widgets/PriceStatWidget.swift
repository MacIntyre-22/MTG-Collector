//
//  PriceStatWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-23.
//  Purpose:
//      Displays the price of a collection in a widget style

// MARK: Imports

import SwiftUI

// MARK: Types

struct PriceStatWidget: View {
    
    // MARK: Stored Properties

    var price: Double
    
    // MARK: View

    var body: some View {
        ZStack {
            VStack {
                Label("Cost", systemImage: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.gray)
                    .italic()
                Text(price, format: .currency(code: "CAD"))
                    .lineLimit(1)
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: 270, maxHeight: 100)
            .aspectRatio(1, contentMode: .fill)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.18), radius: 6, x: 0, y: 0)
            )
        }
    }
}
