//
//  InfoPriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays different prices from a prices object
//  External Types:
//      Prices, PriceWidget

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoPriceWidget: View {

    // MARK: Stored Properties

    var prices: Prices
    
    // MARK: View

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if !prices.usd.isEmpty {
                        PriceWidget(finish: "Base", price: prices.usd)
                    }

                    if !prices.usdFoil.isEmpty {
                        PriceWidget(finish: "Foil", price: prices.usdFoil)
                    }

                    if !prices.usdEtched.isEmpty {
                        PriceWidget(finish: "Etched", price: prices.usdEtched)
                    }

                    // EUR (Cardmarket) + MTGO tix
                    if !prices.eur.isEmpty {
                        PriceWidget(finish: "EUR", price: prices.eur, symbol: "€")
                    }

                    if !prices.eurFoil.isEmpty {
                        PriceWidget(finish: "EUR Foil", price: prices.eurFoil, symbol: "€")
                    }

                    if !prices.tix.isEmpty {
                        PriceWidget(finish: "Tix", price: prices.tix, symbol: "")
                    }
                }
            }
            .padding(15)
            .cornerRadius(9)
            .widgetStyle()
        }
    }
}

