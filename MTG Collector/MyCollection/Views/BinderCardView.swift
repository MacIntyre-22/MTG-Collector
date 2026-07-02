//
//  BinderCardView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-09.
//  Purpose:
//      The view used to display cards in the binder view. The card data is supplied by the parent
//      from its shared lookup (so cells don't each hit SwiftData while scrolling); a per-cell
//      fallback resolves anything the parent hasn't provided yet (a just-added or uncached card).
//  External Types:
//      CardEntry, Card, CardStore, CardInfoView, CardEntryView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct BinderCardView: View {

    // MARK: Stored Properties

    var entry: CardEntry
    /// Card supplied by the parent (from its shared lookup). Nil until the parent has it cached.
    var card: Card?
    var deleteEntry: () -> Void
    var showPreviews: Bool
    var showControls: Bool

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appTint) private var tint
    /// Fallback resolution for a card the parent didn't provide (just-added / uncached).
    @State private var fallback: Card?
    @State private var selectedCard: Card?

    // MARK: Computed

    /// The card to render: parent-provided, else the per-cell fallback.
    private var shownCard: Card? { card ?? fallback }

    /// Setting the finish changes which price counts toward the binder's value, so recompute stats.
    private var finishBinding: Binding<CardFinish> {
        Binding(
            get: { entry.finish },
            set: { newValue in
                entry.finish = newValue
                entry.updatedAt = Date()
                if let binder = entry.binder {
                    StatsUpdater.update(binder, context: modelContext)
                }
            }
        )
    }

    // MARK: View

    var body: some View {
        ZStack(alignment: .topLeading) {
            Button {
                if let shownCard { selectedCard = shownCard }
            } label: {
                CardEntryView(
                    entry: entry,
                    card: shownCard,
                    showPreviews: showPreviews,
                    showControls: showControls,
                    deleteEntry: { deleteEntry() }
                )
            }
            .buttonStyle(.plain)

            if showControls {
                VStack {
                    Menu {
                        Picker("Finish", selection: finishBinding) {
                            ForEach(CardFinish.allCases, id: \.self) { Text($0.label).tag($0) }
                        }

                        Button(entry.favourite ? "Unfavourite" : "Favourite") {
                            entry.favourite.toggle()
                            entry.updatedAt = Date()
                        }

                        Button("Delete", role: .destructive) {
                            deleteEntry()
                        }

                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(tint)
                            .cornerRadius(5)
                            .bold()
                            .shadow(radius: 4)
                    }
                    .padding(5)
                }
                .padding(.top, 30)
            }
        }
        // Only resolve when the parent hasn't supplied this card (rare) — most cells render straight
        // from the provided `card`, so scrolling never triggers a SwiftData fetch.
        .task(id: entry.scryfallCardID) {
            if card == nil, fallback == nil {
                fallback = await CardStore.resolve(entry.scryfallCardID, context: modelContext)
            }
        }
        .cardInfoSheet(card: $selectedCard)
    }
}
