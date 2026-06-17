//
//  InfoPriceWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays a card's available prices in the user's selected currency. Prices are filtered to
//      whatever finishes actually have a value for that currency (handled by Currency.cardPrices).
//  External Types:
//      Prices, PriceWidget

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoPriceWidget: View {

    // MARK: Stored Properties

    var prices: Prices

    @Environment(\.appCurrency) private var currency

    // MARK: View

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(currency.cardPrices(prices), id: \.finish) { item in
                    PriceWidget(finish: item.finish, price: item.price)
                }
            }
        }
        .padding(15)
        .cornerRadius(9)
        .widgetStyle()
    }
}
