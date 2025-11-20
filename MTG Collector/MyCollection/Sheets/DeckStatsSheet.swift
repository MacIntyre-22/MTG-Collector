//
//  DeckStatsSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-10.
//  Purpose:
//      Displays the stats for the respective deck
//  External Types:
//      Deck, StatWidget, LegalWidget, PriceWidget, ManaCountWidget, TypeCountWidget

// MARK: Imports

import SwiftUI

// MARK: Types

struct DeckStatsSheet: View {
    
    // MARK: Stored Properties
    
    var deck: Deck
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack(spacing: 20) {
                        StatWidget(text: "\(deck.cardCount)", label: Label("Cards", systemImage: "square.stack"))
                        StatWidget(text: "\(deck.landCount)", label: Label("Lands", systemImage: "mountain.2"))
                    }
                    .padding(.bottom, 10)

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
                    
                    ManaCountWidget(manaTypeCount: deck.manaTypeCount)
                        .padding(.bottom, 10)
                    
                    TypeCountWidget(cardTypeCount: deck.cardTypeCount)
                        .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }
}

