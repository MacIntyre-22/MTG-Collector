//
//  BinderStatsSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-10.
//

import SwiftUI

struct BinderStatsSheet: View {
    var binder: Binder
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    HStack(spacing: 20) {
                        // card count
                        StatWidget(text: "\(binder.cardCount)", label: Label("Cards", systemImage: "square.stack"))
                        
                        // Totals price
                        PriceStatWidget(price: binder.totalPrice)
                    }
                    .padding(.bottom, 20)
                    
                    // highest priced card
                    if let entry = binder.highestPricedCard {
                        HighCardWidget(entry: entry)
                            .padding(.bottom, 10)

                    }
                    // 2 row span
                    ManaCountWidget(manaTypeCount: binder.manaTypeCount)
                        .padding(.bottom, 10)
                    
                    // 2 row span
                    TypeCountWidget(cardTypeCount: binder.cardTypeCount)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        // unique cards
                        // StatWidget(text: "\(binder.uniqueCardCount)", label: Label("Unique Cards", systemImage: "star"))
                    }
                    .padding(.bottom, 20)
                    
                    
                    
                    
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }
}

