//
//  BinderCardView.swift
//  Card Hoard
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
    @State private var card: Card?

    // MARK: View

    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink {
                if let card {
                    CardInfoView(card: card)
                }
            } label: {
                CardEntryView(
                    entry: entry,
                    card: card,
                    showPreviews: showPreviews,
                    showControls: showControls,
                    deleteEntry: { deleteEntry() }
                )
            }

            if showControls {
                VStack {
                    Menu {
                        Button("Toggle Foil") {
                            entry.isFoil.toggle()
                            entry.updatedAt = Date()
                        }

                        Button("Delete", role: .destructive) {
                            deleteEntry()
                        }

                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.accentColor)
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
    }
}
