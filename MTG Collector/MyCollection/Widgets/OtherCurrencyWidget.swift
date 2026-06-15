//
//  OtherCurrencyWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Shows a collection's EUR (Cardmarket) and MTGO tix totals alongside the USD total.
//      Renders nothing when both are zero. A full currency preference lives in Settings
//      (Phase 4) — this surfaces the values now stored in CollectionStats.

// MARK: Imports

import SwiftUI

// MARK: Types

struct OtherCurrencyWidget: View {

    // MARK: Stored Properties

    var eur: Double
    var tix: Double

    // MARK: View

    var body: some View {
        if eur > 0 || tix > 0 {
            HStack(spacing: 20) {
                if eur > 0 {
                    StatWidget(
                        text: eur.formatted(.currency(code: "EUR")),
                        label: Label("EUR", systemImage: "eurosign.circle")
                    )
                }
                if tix > 0 {
                    StatWidget(
                        text: String(format: "%.2f tix", tix),
                        label: Label("MTGO", systemImage: "circle.grid.cross")
                    )
                }
            }
        }
    }
}
