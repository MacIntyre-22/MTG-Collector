//
//  CollectionSnapshot.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      A frozen, Codable copy of a deck or binder for sharing. Carries only the lightweight user
//      data (name, notes, rule type, card IDs + quantity/foil/board, optional cover image) — card
//      details are re-resolved from Scryfall by ID on the receiving device, so a shared collection
//      rebuilds itself fully, art included. Snapshots are one-way copies: edits never propagate.
//  External Types:
//      Deck, Binder, CardEntry, DeckBoard, ImageManager, StatsUpdater
//

// MARK: Imports

import Foundation
import SwiftData
import UIKit

// MARK: Snapshot

struct CollectionSnapshot: Codable {

    enum Kind: String, Codable { case deck, binder }

    /// One card in the snapshot — just an ID plus the user's metadata.
    struct Card: Codable {
        var scryfallID: String
        var quantity: Int
        var isFoil: Bool
        var board: String?   // DeckBoard raw value, nil for binders
        var role: String?    // leader role ("commander"/"oathbreaker"/"signature"); nil for board cards
    }

    var version: Int = 1
    var kind: Kind
    var name: String
    var notes: String
    var ruleType: String?        // deck only
    var cards: [Card]
    var commander: Card?         // deck only

    /// The cover photo travels separately as a CloudKit asset; this is only used for small
    /// self-contained encodings. Kept out of the CloudKit `snapshot` field to stay under 1 MB.
    var coverImageData: Data?
}

// MARK: Build from model

@MainActor
enum CollectionSnapshotFactory {

    /// Snapshot a deck (boards preserved). Returns the snapshot and its cover image, if any.
    static func make(from deck: Deck) -> (snapshot: CollectionSnapshot, cover: UIImage?) {
        // Leaders are flagged mainboard cards, so each card is emitted once, carrying its role.
        func cards(_ entries: [CardEntry], board: DeckBoard) -> [CollectionSnapshot.Card] {
            entries.filter { !$0.isDeleted }.map {
                CollectionSnapshot.Card(scryfallID: $0.scryfallCardID, quantity: $0.quantity,
                                        isFoil: $0.isFoil, board: board.rawValue,
                                        role: $0.role.isEmpty ? nil : $0.role)
            }
        }
        var all = cards(deck.mainboard, board: .mainboard)
        all += cards(deck.sideboard, board: .sideboard)
        all += cards(deck.maybeboard, board: .maybeboard)

        let snapshot = CollectionSnapshot(kind: .deck, name: deck.name, notes: deck.notes,
                                          ruleType: deck.ruleType, cards: all, commander: nil)
        return (snapshot, deck.coverUIImage)
    }

    /// Snapshot a binder (flat list).
    static func make(from binder: Binder) -> (snapshot: CollectionSnapshot, cover: UIImage?) {
        let cards = binder.activeCards.map {
            CollectionSnapshot.Card(scryfallID: $0.scryfallCardID, quantity: $0.quantity,
                                    isFoil: $0.isFoil, board: nil)
        }
        let snapshot = CollectionSnapshot(kind: .binder, name: binder.name, notes: binder.notes,
                                          ruleType: nil, cards: cards, commander: nil)
        return (snapshot, binder.coverUIImage)
    }
}

// MARK: Import into model

@MainActor
enum CollectionSnapshotImporter {

    /// The result of importing a snapshot: the new collection's id + kind (for routing) and its
    /// card IDs (for cache priming).
    struct Imported {
        let id: String
        let kind: CollectionSnapshot.Kind
        let cardIDs: [String]
    }

    /// Create a brand-new deck or binder from a snapshot (a copy — never linked to the original).
    /// Card data resolves lazily by ID via CardStore, exactly like any other added card.
    static func importSnapshot(_ snapshot: CollectionSnapshot, cover: UIImage?, context: ModelContext) -> Imported {
        switch snapshot.kind {
        case .deck:   return importDeck(snapshot, cover: cover, context: context)
        case .binder: return importBinder(snapshot, cover: cover, context: context)
        }
    }

    private static func importDeck(_ snapshot: CollectionSnapshot, cover: UIImage?, context: ModelContext) -> Imported {
        let deck = Deck(name: snapshot.name, notes: snapshot.notes, ruleType: snapshot.ruleType ?? "casual")
        for card in snapshot.cards {
            let entry = CardEntry(scryfallCardID: card.scryfallID, quantity: card.quantity, isFoil: card.isFoil)
            if let role = card.role, !role.isEmpty {
                deck.designateImportedLeader(entry, role: role)
                continue
            }
            switch DeckBoard(rawValue: card.board ?? "mainboard") ?? .mainboard {
            case .mainboard: deck.mainboard.append(entry)
            case .sideboard: deck.sideboard.append(entry)
            case .maybeboard: deck.maybeboard.append(entry)
            case .commander: deck.designateImportedLeader(entry)
            }
        }
        // Legacy snapshots carried the commander in a separate field.
        if let c = snapshot.commander {
            deck.designateImportedLeader(CardEntry(scryfallCardID: c.scryfallID, quantity: c.quantity, isFoil: c.isFoil))
        }
        deck.inCollection = false   // a shared list is someone else's — don't roll it into owned totals
        deck.setCover(cover)
        context.insert(deck)
        DeckColors.refresh(deck, context: context)
        StatsUpdater.update(deck, context: context)
        return Imported(id: deck.id, kind: .deck, cardIDs: deck.allCardIDs)
    }

    private static func importBinder(_ snapshot: CollectionSnapshot, cover: UIImage?, context: ModelContext) -> Imported {
        let binder = Binder(name: snapshot.name, notes: snapshot.notes)
        for card in snapshot.cards {
            binder.cards.append(CardEntry(scryfallCardID: card.scryfallID, quantity: card.quantity, isFoil: card.isFoil))
        }
        binder.inCollection = false   // a shared list is someone else's — don't roll it into owned totals
        binder.setCover(cover)
        context.insert(binder)
        StatsUpdater.update(binder, context: context)
        return Imported(id: binder.id, kind: .binder, cardIDs: binder.cards.map(\.scryfallCardID))
    }
}

// MARK: Convenience

extension Deck {
    /// All card IDs across boards, for cache priming after an import (leaders live in the mainboard).
    var allCardIDs: [String] {
        (mainboard + sideboard + maybeboard).map(\.scryfallCardID)
    }
}
