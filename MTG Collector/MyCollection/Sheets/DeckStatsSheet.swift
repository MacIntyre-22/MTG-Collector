//
//  DeckStatsSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-10.
//

import SwiftUI

struct DeckStatsSheet: View {
    var deck: Deck
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    // grid style , but its static
                    // two widgets
                    HStack(spacing: 20) {
                        // card count
                        StatWidget(text: "\(deck.cardCount)", label: Label("Cards", systemImage: "square.stack"))
                        
                        StatWidget(text: "\(deck.landCount)", label: Label("Lands", systemImage: "mountain.2"))
                    }
                    .padding(.bottom, 10)

                    // two widgets
                    HStack(spacing: 20) {
                        StatWidget(text: String(format: "%.1f", deck.avgManaCost), label: Label("Avg. Mana", systemImage: "bolt"))
                        
                        LegalWidget(isLegal: deck.isLegal, ruleType: deck.ruleType)
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        StatWidget(text: "\(deck.uniqueCount)", label: Label("Unique", systemImage: "sparkle"))
                        
                        PriceStatWidget(price: deck.totalPrice)
                    }
                    .padding(.bottom, 10)
                    
                    // 2 row span
                    ManaCountWidget(manaTypeCount: deck.manaTypeCount)
                        .padding(.bottom, 10)
                    
                    // 2 row span
                    TypeCountWidget(cardTypeCount: deck.cardTypeCount)
                        .padding(.bottom, 10)
                    
                    
                    
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }
}

