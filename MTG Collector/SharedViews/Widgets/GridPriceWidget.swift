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

    @Environment(\.appCurrency) private var currency

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

    /// Foil and Etched get the subtle linear shimmer; Base stays calm.
    var shine: ShineLevel {
        switch finish {
        case "Foil", "Etched": return .linear
        default: return .none
        }
    }

    /// Holo colours per finish (Foil = rainbow, Etched = silvery chrome).
    var holoColors: [Color] {
        switch finish {
        case "Foil": return [.blue, .purple, .pink, .orange, .yellow, .green]
        case "Etched": return [.gray, .white, .black, .gray, .white]
        default: return [tint]
        }
    }

    // MARK: View

    var body: some View {
        Text(currency.format(price))
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .holoPill(level: shine, colors: holoColors, tint: tint)
    }
}

