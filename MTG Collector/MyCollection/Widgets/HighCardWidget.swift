//
//  HighCardWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-14.
//

import SwiftUI

struct HighCardWidget: View {
    var entry: CardEntry
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Highest Priced Card")
                    .font(.title3)
                    .bold()
                HStack(spacing: 20) {
                    CardImageView(maxWidth: 100, name: entry.card.name, imageURIs: entry.card.imageURIs)
                    VStack(alignment: .leading) {
                        
                        // name
                        Text(entry.card.name)
                        
                        // stats
                        // show rarity
                        if !entry.card.rarity.isEmpty {
                            GridRarityWidget(rarity: entry.card.rarity)
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // show price
                                // display each price from prices obj
                                if !entry.card.prices.usd.isEmpty {
                                    GridPriceWidget(finish: "Base", price: entry.card.prices.usd)
                                }
                                
                                if !entry.card.prices.usdFoil.isEmpty {
                                    GridPriceWidget(finish: "Foil", price: entry.card.prices.usdFoil)
                                }
                                
                                if !entry.card.prices.usdEtched.isEmpty {
                                    GridPriceWidget(finish: "Etched", price: entry.card.prices.usdEtched)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.18), radius: 15, x: 0, y: 0)
            )
        }
    }
}

