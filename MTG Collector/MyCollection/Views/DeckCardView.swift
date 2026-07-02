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
    /// Card supplied by the parent board (from its shared lookup). Nil until it's cached.
    var card: Card?
    var deleteEntry: () -> Void

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appTint) private var tint
    /// Fallback resolution for a card the parent didn't provide (just-added / uncached).
    @State private var fallback: Card?
    @State private var selectedCard: Card?

    // MARK: Computed Properties

    /// The card to render: parent-provided, else the per-cell fallback.
    private var shownCard: Card? { card ?? fallback }

    /// Legal status for this card in the deck's format (needs resolved card data).
    var legality: LegalityStatus {
        guard let shownCard else { return .unknown }
        return LegalityStatus.of(shownCard, ruleType: deck.ruleType)
    }

    /// The owned finish (metadata for export/sharing). Deck value always uses base price, so this
    /// doesn't trigger a stats recompute.
    private var finishBinding: Binding<CardFinish> {
        Binding(
            get: { entry.finish },
            set: { entry.finish = $0; entry.updatedAt = Date() }
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
                    showPreviews: deck.showPreviews,
                    showControls: deck.showControls,
                    legalityIcon: legality.isProblem ? legality.icon : nil,
                    legalityColor: legality.color,
                    deleteEntry: { deleteEntry() }
                )
            }
            .buttonStyle(.plain)

            if deck.showControls {
                VStack {
                    Menu {
                        /// Controls
                        Picker("Finish", selection: finishBinding) {
                            ForEach(CardFinish.allCases, id: \.self) { Text($0.label).tag($0) }
                        }
                        // Leader slots for this deck's game mode (Commander, Oathbreaker, Signature
                        // Spell, …) — generated from DeckRules, so no slot is hardcoded.
                        ForEach(DeckRules.leaderSlots(for: deck.ruleType)) { slot in
                            Button("Make \(slot.label)") {
                                deck.setLeader(entry, slot: slot)
                                DeckColors.refresh(deck, context: modelContext)
                                StatsUpdater.update(deck, context: modelContext)
                            }
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
        // Only resolve when the parent board hasn't supplied this card — most cells render from the
        // provided `card`, so scrolling a board never triggers a per-cell SwiftData fetch.
        .task(id: entry.scryfallCardID) {
            if card == nil, fallback == nil {
                fallback = await CardStore.resolve(entry.scryfallCardID, context: modelContext)
            }
        }
        .cardInfoSheet(card: $selectedCard)
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
