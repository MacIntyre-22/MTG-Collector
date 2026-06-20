//
//  CollectionImportBuilder.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Turns resolved import cards into SwiftData records — appending CardEntries to a deck's
//      boards or a binder's flat list (new or existing). Caches the resolved card data so entries
//      resolve later without another fetch, and refreshes stats. Also builds the ExportRow list
//      for the export path (the inverse direction). MainActor: touches the model context.
//  External Types:
//      Deck, Binder, CardEntry, ResolvedDeckCard, ExportRow, CardStore, SFAPI, StatsUpdater
//

// MARK: Imports

import Foundation
import SwiftData

// MARK: Builder

@MainActor
enum CollectionImportBuilder {

    // MARK: Import → model

    /// Append resolved cards to a deck's boards, caching card data and refreshing stats.
    static func add(_ resolved: [ResolvedDeckCard], to deck: Deck, context: ModelContext) {
        guard !resolved.isEmpty else { return }
        cache(resolved, context: context)

        for item in resolved {
            guard let id = item.card.id else { continue }
            let entry = CardEntry(scryfallCardID: id, quantity: item.line.quantity, isFoil: item.line.isFoil)
            switch item.line.board {
            case .mainboard: deck.mainboard.append(entry)
            case .sideboard: deck.sideboard.append(entry)
            case .maybeboard: deck.maybeboard.append(entry)
            case .commander: deck.designateImportedLeader(entry)
            }
        }
        deck.editedAt = Date()
        deck.updatedAt = Date()
        DeckColors.refresh(deck, context: context)
        StatsUpdater.update(deck, context: context)
    }

    /// Append resolved cards to a binder's flat list (board is ignored), caching + refreshing stats.
    static func add(_ resolved: [ResolvedDeckCard], to binder: Binder, context: ModelContext) {
        guard !resolved.isEmpty else { return }
        cache(resolved, context: context)

        for item in resolved {
            guard let id = item.card.id else { continue }
            binder.cards.append(CardEntry(scryfallCardID: id, quantity: item.line.quantity, isFoil: item.line.isFoil))
        }
        binder.editedAt = Date()
        binder.updatedAt = Date()
        StatsUpdater.update(binder, context: context)
    }

    private static func cache(_ resolved: [ResolvedDeckCard], context: ModelContext) {
        CardStore.cache(resolved.map { SFAPI.JSONtoModel(json: $0.card) }, context: context)
    }

    // MARK: Model → export rows

    /// Build export rows for a deck, board by board (mainboard, commander, sideboard, maybeboard).
    static func exportRows(for deck: Deck, context: ModelContext) -> [ExportRow] {
        let allEntries = deck.activeMainboard
            + deck.sideboard.filter { !$0.isDeleted }
            + deck.maybeboard.filter { !$0.isDeleted }
        let cards = CardStore.lookup(for: allEntries.map(\.scryfallCardID), context: context)

        func rows(_ entries: [CardEntry], board: DeckBoard) -> [ExportRow] {
            entries.filter { !$0.isDeleted }.map { row(for: $0, cards: cards, board: board) }
        }

        // Leaders are flagged mainboard cards — export them once under the "Commander" section
        // (standard deck text formats only have that one leader header) and the rest as mainboard.
        var out = rows(deck.activeMainboard.filter { $0.role.isEmpty }, board: .mainboard)
        for leader in deck.activeLeaders {
            out.append(row(for: leader, cards: cards, board: .commander))
        }
        out += rows(deck.sideboard, board: .sideboard)
        out += rows(deck.maybeboard, board: .maybeboard)
        return out
    }

    /// Build export rows for a binder (flat, no board headers).
    static func exportRows(for binder: Binder, context: ModelContext) -> [ExportRow] {
        let entries = binder.activeCards
        let cards = CardStore.lookup(for: entries.map(\.scryfallCardID), context: context)
        return entries.map { row(for: $0, cards: cards, board: nil) }
    }

    private static func row(for entry: CardEntry, cards: [String: Card], board: DeckBoard?) -> ExportRow {
        let card = cards[entry.scryfallCardID]
        return ExportRow(
            quantity: entry.quantity,
            name: card?.name ?? "Unknown Card",
            setCode: card?.set ?? "",
            collectorNumber: card?.collectorNumber ?? "",
            isFoil: entry.isFoil,
            board: board
        )
    }
}
