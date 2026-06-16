//
//  PricePill.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Reusable price pill for collection prices (binder/deck headers, list rows, etc.).
//      Renders the formatted price on tinted glass. The `tint` parameter exists so price colour
//      can later react to context (e.g. value thresholds, currency) from one place.
//  External Types:
//      (none)
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct PricePill: View {

    // MARK: Stored Properties

    var price: Double
    var currencyCode: String = "CAD"
    /// Colour for both the text and the glass tint (defaults to the existing green-on-green).
    var tint: Color = .green

    // MARK: View

    var body: some View {
        Text(price, format: .currency(code: currencyCode))
            .padding(5)
            // lighten the text relative to the tint so it reads light-on-dark on the glass
            .foregroundColor(tint.mix(with: .white, by: 0.5))
            .pillStyle(.tinted(tint))
    }
}
