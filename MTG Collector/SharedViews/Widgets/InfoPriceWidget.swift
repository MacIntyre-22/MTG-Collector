//
//  InfoPriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct InfoPriceWidget: View {
    var prices: [String: String?]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // display each price from prices dict
                ForEach(prices.keys.sorted(), id: \.self) { key in
                    // only display if price has a value
                    if let priceOptional = prices[key], let price = priceOptional, !price.isEmpty {
                        PriceWidget(finish: key, price: price)
                    }
                }
            }
            .padding()
        }
    }
}

