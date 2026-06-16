//
//  GridPriceWidget.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays the price and finish passed to it

// MARK: Imports

import SwiftUI

// MARK: Types

struct GridPriceWidget: View {
    
    // MARK: Stored Properties

    var finish: String
    var price: String

    // MARK: Computed Properties

    /// Tint colour per finish — keeps the finish meaning while adopting glass.
    var tint: Color {
        switch finish {
        case "Base": return .gray
        case "Foil": return .purple
        case "Etched": return .gray
        default: return .blue
        }
    }

    // MARK: View

    var body: some View {
        Text("$\(price)")
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .glassEffect(.regular.tint(tint), in: RoundedRectangle(cornerRadius: 5))
    }
}

