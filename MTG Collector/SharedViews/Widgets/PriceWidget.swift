//
//  PriceWidget.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-29.
//  Purpose:
//      Displays a pricewidget with given finish and price
//  External Types:
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct PriceWidget: View {
    
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
        VStack(alignment: .leading) {
            Text(finish.capitalized)
                .bold()
                .italic()
                .foregroundColor(.white)
                .padding(5)
                .holoPill(level: shine, colors: holoColors, tint: tint)

            Spacer()

            Text(currency.format(price))
                .frame(width: 80, alignment: .trailing)
                .bold()
                .foregroundColor(.green)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .padding(10)
        .frame(width: 100, height: 100)
        .widgetStyle()
    }
}

