//
//  BinderStatsSheet.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-10-10.
//  Pourpose:
//      Displays the stats for the respective binder
//  External Types:
//      Binder, StatWidget, PriceStatWidget, HighCardWidget, ManaCountWidget, TypeCountWidget,

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct BinderStatsSheet: View {

    // MARK: Stored Properties

    var binder: Binder

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack(spacing: 20) {
                        StatWidget(text: "\(binder.cardCount)", label: Label("Cards", systemImage: "square.stack"))
                        PriceStatWidget(price: binder.totalPrice)
                    }
                    .padding(.bottom, 20)

                    if !binder.highestPricedCardID.isEmpty {
                        HighCardWidget(cardID: binder.highestPricedCardID)
                            .padding(.bottom, 10)
                    }

                    ManaCountWidget(manaTypeCount: binder.manaTypeCount)
                        .padding(.bottom, 10)

                    TypeCountWidget(cardTypeCount: binder.cardTypeCount)
                        .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .task {
                StatsUpdater.update(binder, context: modelContext)
            }
        }
    }
}

