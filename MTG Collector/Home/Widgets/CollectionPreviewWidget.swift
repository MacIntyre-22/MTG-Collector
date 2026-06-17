//
//  CollectionPreviewWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Pinned top-of-Home summary of the user's collection — reuses WholeCollectionStatsWidget over
//      all non-deleted binders and decks, or shows a gentle prompt when nothing is saved yet. Reads
//      stored CollectionStats, so it stays current and resolves no card data.
//  External Types:
//      Binder, Deck, WholeCollectionStatsWidget
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CollectionPreviewWidget: View {

    // MARK: Stored Properties

    @Query private var binders: [Binder]
    @Query private var decks: [Deck]

    private var activeBinders: [Binder] { binders.filter { !$0.isDeleted } }
    private var activeDecks: [Deck] { decks.filter { !$0.isDeleted } }

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("My Hold", systemImage: "rectangle.stack.fill")
                .font(.title2)
                .bold()
                .padding(.horizontal, 5)

            if activeBinders.isEmpty && activeDecks.isEmpty {
                Text("Start a binder, deck or add cards to your hold to see your collection summary here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .widgetStyle()
            } else {
                WholeCollectionStatsWidget(binders: activeBinders, decks: activeDecks)
            }
        }
    }
}
