//
//  DeckCardView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-09.
//  Purpose:
//      Displays cards for a deck view. Resolves the entry's card via CardStore, derives the
//      per-card legality status from the resolved data, and enables board controls.
//  External Types:
//      Deck, CardEntry, Card, CardStore, CardInfoView, CardEntryView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct DeckCardView: View {

    // MARK: Stored Properties

    var deck: Deck
    var entry: CardEntry
    var deleteEntry: () -> Void

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var card: Card?

    // MARK: Computed Properties

    /// Legal status for this card in the deck's format (needs resolved card data).
    var legality: LegalityStatus {
        guard let card else { return .unknown }
        return LegalityStatus.of(card, ruleType: deck.ruleType)
    }

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
                    showPreviews: deck.showPreviews,
                    showControls: deck.showControls,
                    deleteEntry: { deleteEntry() }
                )
            }

            if deck.showControls {
                VStack {
                    Menu {
                        /// Controls
                        Button("Toggle Foil") {
                            entry.isFoil.toggle()
                            entry.updatedAt = Date()
                        }
                        Button("Make Commander") {
                            deck.commander = entry
                        }
                        Button("Mainboard") {
                            mvtoMain(entry: entry)
                        }
                        Button("Sideboard") {
                            mvtoSideboard(entry: entry)
                        }
                        Button("Maybeboard") {
                            mvtoMaybeboard(entry: entry)
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

                    /// Show legal status if there's a problem
                    if legality.isProblem {
                        Image(systemName: legality.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(legality.color)
                            .bold()
                            .shadow(radius: 4)
                    }
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

    // MARK: Board Moving Functions

    func removeAll(entry: CardEntry) {
        deck.mainboard.removeAll { $0.id == entry.id }
        deck.sideboard.removeAll { $0.id == entry.id }
        deck.maybeboard.removeAll { $0.id == entry.id }
    }

    func mvtoMain(entry: CardEntry) {
        removeAll(entry: entry)
        deck.mainboard.append(entry)
        StatsUpdater.update(deck, context: modelContext)
    }

    func mvtoSideboard(entry: CardEntry) {
        removeAll(entry: entry)
        deck.sideboard.append(entry)
        StatsUpdater.update(deck, context: modelContext)
    }

    func mvtoMaybeboard(entry: CardEntry) {
        removeAll(entry: entry)
        deck.maybeboard.append(entry)
        StatsUpdater.update(deck, context: modelContext)
    }
}
