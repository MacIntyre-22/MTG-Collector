//
//  MyCollectionTabView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      The tab view for a user's collection. Shows a whole-collection summary, buttons through
//      to the Binders and Decks lists, and the permanent General Collection inline (a catch-all
//      `Binder` with isGeneral == true, auto-created on first launch).
//  External Types:
//      Binder, Deck, WholeCollectionStatsWidget, AllBindersView, AllDecksView, BinderCardView, StatsUpdater
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct MyCollectionTabView: View {

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query var binders: [Binder]
    @Query var decks: [Deck]

    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]

    // MARK: Derived Data

    private var generalBinder: Binder? {
        binders.first(where: { $0.isGeneral })
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    WholeCollectionStatsWidget(binders: binders, decks: decks)
                        .padding(.horizontal, 10)

                    HStack(spacing: 15) {
                        NavigationLink(destination: AllBindersView()) {
                            collectionButton(image: "MtgBinder", label: "Binders")
                        }
                        NavigationLink(destination: AllDecksView()) {
                            collectionButton(image: "MtgDeck", label: "Decks")
                        }
                    }
                    .padding(.horizontal, 10)

                    if let general = generalBinder {
                        generalSection(general)
                    }
                }
                .padding(.top, 10)
            }
            .navigationTitle("My Collection")
            .task {
                ensureGeneralCollection()
                refreshStats()
            }
        }
    }

    // MARK: Subviews

    private func collectionButton(image: String, label: String) -> some View {
        VStack(spacing: 8) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.primary)
            Text(label)
                .font(.title3)
                .bold()
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 120)
        .widgetStyle()
    }

    @ViewBuilder
    private func generalSection(_ general: Binder) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Cards")
                    .font(.title2)
                    .bold()
                Spacer()
                Image(systemName: "square.stack")
                    .foregroundStyle(.secondary)
                Text("\(general.cardCount)")
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 10)

            if general.activeCards.isEmpty {
                Text("Add cards here without making a binder or deck.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            } else {
                LazyVGrid(columns: cardColumns) {
                    ForEach(general.activeCards.sorted(by: { $0.dateAdded > $1.dateAdded })) { entry in
                        BinderCardView(
                            entry: entry,
                            deleteEntry: {
                                general.cards.removeAll(where: { $0.id == entry.id })
                                StatsUpdater.update(general, context: modelContext)
                            },
                            showPreviews: general.showPreviews,
                            showControls: general.showControls
                        )
                    }
                }
                .padding(.horizontal, 10)
            }
        }
    }

    // MARK: Helpers

    /// Create the permanent "My Collection" catch-all binder on first launch if it's missing,
    /// and normalise the name of any binder created under the old "General Collection" label.
    private func ensureGeneralCollection() {
        if let general = binders.first(where: { $0.isGeneral }) {
            if general.name == "General Collection" {
                general.name = "My Collection"
            }
        } else {
            let general = Binder(name: "My Collection", isGeneral: true)
            modelContext.insert(general)
        }
    }

    /// Keep stored stats current so the whole-collection summary is accurate.
    private func refreshStats() {
        for binder in binders {
            StatsUpdater.update(binder, context: modelContext)
        }
        for deck in decks {
            StatsUpdater.update(deck, context: modelContext)
        }
    }
}
