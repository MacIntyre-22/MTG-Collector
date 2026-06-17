//
//  PricePill.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Reusable price pill for collection totals (binder/deck headers, list rows). Reads the
//      stored CollectionStats and the user's display currency (appCurrency environment) so the
//      shown value + currency stay consistent everywhere. The `tint` parameter exists for future
//      colour logic.
//  External Types:
//      CollectionStats, AppCurrency
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct PricePill: View {

    // MARK: Stored Properties

    var stats: CollectionStats?
    /// Colour for the text + glass tint (defaults to green-on-green).
    var tint: Color = .green

    @Environment(\.appCurrency) private var currency

    // MARK: View

    var body: some View {
        Text(currency.format(currency.total(stats)))
            .padding(5)
            // lighten the text relative to the tint so it reads light-on-dark on the glass
            .foregroundColor(tint.mix(with: .white, by: 0.5))
            .pillStyle(.tinted(tint))
    }
}
