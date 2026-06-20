//
//  BinderCardView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-09.
//  Purpose:
//      The view used to display cards in the binder view. Resolves the entry's card data via
//      CardStore, then hands it to CardEntryView and the CardInfoView destination.
//  External Types:
//      CardEntry, Card, CardStore, CardInfoView, CardEntryView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct BinderCardView: View {

    // MARK: Stored Properties

    var entry: CardEntry
    var deleteEntry: () -> Void
    var showPreviews: Bool
    var showControls: Bool

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appTint) private var tint
    @State private var card: Card?
    @State private var selectedCard: Card?

    // MARK: Computed

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
                if let card { selectedCard = card }
            } label: {
                CardEntryView(
                    entry: entry,
                    card: card,
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
        .task {
            if card == nil {
                card = await CardStore.resolve(entry.scryfallCardID, context: modelContext)
            }
        }
        .cardInfoSheet(card: $selectedCard)
    }
}
