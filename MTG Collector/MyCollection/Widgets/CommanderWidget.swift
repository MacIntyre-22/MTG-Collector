//
//  CommanderWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-09.
//  Purpose:
//      Displays one of a deck's designated leader cards (commander, oathbreaker, signature spell, …).
//      The `label` is the slot title from DeckRules, so the same widget serves every game mode.
//      Resolves the card via CardStore.
//  External Types:
//      CardEntry, Card, CardStore, CardInfoView, CardImageView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CommanderWidget: View {

    // MARK: Stored Properties

    var entry: CardEntry
    /// Slot title from DeckRules (e.g. "Commander", "Oathbreaker", "Signature Spell").
    var label: String = "Commander"
    var remove: () -> Void

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appTint) private var tint
    @Environment(\.appCurrency) private var currency
    @State private var card: Card?
    @State private var selectedCard: Card?

    // MARK: View

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CardImageView(maxWidth: 120, name: card?.name ?? "", imageURIs: card?.imageURIs ?? ImageURIs())

            info
                .frame(maxWidth: .infinity, alignment: .leading)

            Menu {
                Button("Remove", systemImage: "xmark", role: .destructive) { remove() }
            } label: {
                Image(systemName: "pencil.line")
                    .foregroundColor(.white)
                    .padding(5)
                    .background(tint)
                    .cornerRadius(5)
                    .bold()
                    .shadow(radius: 4)
            }
        }
        .foregroundColor(.primary)
        .padding(10)
        .widgetStyle(.translucent)
        .frame(maxWidth: 600)
        // Tap anywhere on the row (except the menu, which captures its own taps) to open the card.
        .contentShape(Rectangle())
        .onTapGesture {
            if let card { selectedCard = card }
        }
        .task {
            if card == nil {
                card = await CardStore.resolve(entry.scryfallCardID, context: modelContext)
            }
        }
        .cardInfoSheet(card: $selectedCard)
    }

    // MARK: Info column (mirrors the scan sheet's detail panel)

    @ViewBuilder
    private var info: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Text(card?.name ?? "Loading…")
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)

            if let card, !card.manaCost.isEmpty {
                ManaCostView(cost: card.manaCost, symbolSize: 16)
                    .lineLimit(1)
            }

            if let card, !card.typeLine.isEmpty {
                Text(card.typeLine)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            if let card {
                HStack(spacing: 8) {
                    SetIconWidget(set: card.set, rarity: card.rarity, maxWidth: 24)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(card.setName.isEmpty ? card.set.uppercased() : card.setName)
                            .font(.caption.bold())
                            .lineLimit(1)
                        Text("#\(card.collectorNumber) · \(card.rarity.capitalized)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                }

                let prices = currency.cardPrices(card.prices)
                if !prices.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(prices, id: \.finish) { item in
                            GridPriceWidget(finish: item.finish, price: item.price)
                        }
                    }
                }
            }
        }
    }
}
