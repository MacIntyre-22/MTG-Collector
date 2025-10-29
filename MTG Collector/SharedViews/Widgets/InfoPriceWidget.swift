//
//  InfoPriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct InfoPriceWidget: View {
    var prices: Prices
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // display each price from prices obj
                    if !prices.usd.isEmpty {
                        PriceWidget(finish: "Base", price: prices.usd)
                    }
                    
                    if !prices.usdFoil.isEmpty {
                        PriceWidget(finish: "Foil", price: prices.usdFoil)
                    }
                    
                    if !prices.usdEtched.isEmpty {
                        PriceWidget(finish: "Etched", price: prices.usdEtched)
                    }
                }
            }
            .padding(15)
            .cornerRadius(9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
}

