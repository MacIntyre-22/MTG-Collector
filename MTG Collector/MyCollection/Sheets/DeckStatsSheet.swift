//
//  DeckStatsSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-10.
//  Purpose:
//      The full stats sheet for a deck. A deck-specific header (mana curve, format legality + deck
//      size, the Commander colour-identity check, per-board totals, and functional roles) sits above
//      the shared CollectionStatsContent — the same counts / value / breakdowns binders use — so the
//      deck view adds only what binders don't have. Board totals, roles, and the identity-check count
//      are computed here from CardCache, since stored stats only describe the mainboard.
//  External Types:
//      Deck, CollectionStatsContent, ManaCurveWidget, LegalWidget, DeckSizeWidget, DeckIdentityWidget,
//      BoardTotalsWidget, BreakdownListWidget, DeckRules, DeckRoleClassifier, CardStore, AppCurrency,
//      StatsUpdater, StatsStore
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct DeckStatsSheet: View {

    // MARK: Stored Properties

    var deck: Deck

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appCurrency) private var currency
    @State private var stats: CollectionStats?
    /// Per-board card count + already-formatted value (display currency), computed from CardCache.
    @State private var boardRows: [(label: String, cards: Int, price: String)] = []
    /// Quantity-weighted functional-role counts (ramp / draw / removal), non-zero only.
    @State private var roleItems: [(label: String, count: Int)] = []
    /// Unique mainboard cards whose colour identity sits outside the deck's (Commander rule).
    @State private var identityOffenders = 0

    /// The deck's game mode designates leaders → the colour-identity rule applies.
    private var enforcesIdentity: Bool { DeckRules.hasLeaders(for: deck.ruleType) }

    /// Role label → tap-to-learn explainer, for the Roles breakdown (beginner hints).
    private var roleInfo: [String: InfoDetail] {
        Dictionary(uniqueKeysWithValues: DeckRoleClassifier.roles.map { ($0.label, $0.infoDetail) })
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 14) {
                    ManaCurveWidget(deck: deck)

                    HStack(spacing: 14) {
                        LegalWidget(
                            isLegal: deck.isLegal,
                            ruleType: deck.ruleType,
                            info: FormatGlossary.infoDetail(ruleType: deck.ruleType, isLegal: deck.isLegal)
                        )
                        DeckSizeWidget(count: deck.cardCount, ruleType: deck.ruleType)
                    }

                    if enforcesIdentity {
                        DeckIdentityWidget(identity: deck.colorIdentity, offenders: identityOffenders)
                    }

                    if !boardRows.isEmpty {
                        BoardTotalsWidget(rows: boardRows)
                    }

                    if !roleItems.isEmpty {
                        BreakdownListWidget(title: "Roles", items: roleItems, info: roleInfo)
                    }

                    // Shared body: counts, value, avg MV, lands, sets, dearest card, and the
                    // rarity / colour / type / set / finish breakdowns, plus deck resource links.
                    CollectionStatsContent(
                        stats: stats,
                        cardCount: deck.cardCount,
                        resources: .deck(deck)
                    )
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .task {
                StatsUpdater.update(deck, context: modelContext)
                stats = StatsStore.stats(for: deck, context: modelContext)
                computeDeckExtras()
            }
        }
    }

    // MARK: Deck-only computations

    /// Per-board totals, functional roles, and the colour-identity offender count — all need card data
    /// (CardCache) that the stored mainboard stats don't carry.
    private func computeDeckExtras() {
        func count(_ entries: [CardEntry]) -> Int { entries.reduce(0) { $0 + $1.quantity } }
        func valueString(_ entries: [CardEntry], _ lookup: [String: Card]) -> String {
            let usd = entries.reduce(0.0) { sum, entry in
                guard let card = lookup[entry.scryfallCardID] else { return sum }
                return sum + AppCurrency.canonicalUSD(card.prices, finish: entry.finish) * Double(entry.quantity)
            }
            return currency.formatCompact(currency.display(usd: usd))
        }

        let mainEntries = deck.activeMainboard
        let sideEntries = deck.sideboard.filter { !$0.isDeleted }
        let maybeEntries = deck.maybeboard.filter { !$0.isDeleted }

        let mainLookup = CardStore.lookup(for: mainEntries.map(\.scryfallCardID), context: modelContext)
        let sideLookup = CardStore.lookup(for: sideEntries.map(\.scryfallCardID), context: modelContext)
        let maybeLookup = CardStore.lookup(for: maybeEntries.map(\.scryfallCardID), context: modelContext)

        // Per-board totals — always show the mainboard; side/maybe only when they hold cards.
        var rows: [(label: String, cards: Int, price: String)] = [
            ("Mainboard", count(mainEntries), valueString(mainEntries, mainLookup))
        ]
        if !sideEntries.isEmpty { rows.append(("Sideboard", count(sideEntries), valueString(sideEntries, sideLookup))) }
        if !maybeEntries.isEmpty { rows.append(("Maybeboard", count(maybeEntries), valueString(maybeEntries, maybeLookup))) }
        boardRows = rows

        // Functional roles (quantity-weighted) over the mainboard, in catalogue order.
        var roleTotals: [String: Int] = [:]
        for entry in mainEntries {
            guard let card = mainLookup[entry.scryfallCardID] else { continue }
            for roleID in DeckRoleClassifier.roles(for: card) {
                roleTotals[roleID, default: 0] += entry.quantity
            }
        }
        roleItems = DeckRoleClassifier.roles.compactMap { role in
            roleTotals[role.id].map { (label: role.label, count: $0) }
        }

        // Colour-identity check (Commander rule): unique mainboard cards whose identity isn't a subset
        // of the deck's. Colourless cards always fit.
        guard enforcesIdentity, !deck.colorIdentity.isEmpty else { identityOffenders = 0; return }
        let allowed = Set(deck.colorIdentity)
        identityOffenders = mainEntries.reduce(into: 0) { offenders, entry in
            guard let card = mainLookup[entry.scryfallCardID] else { return }
            if !Set(card.colorIdentity).isSubset(of: allowed) { offenders += 1 }
        }
    }
}
