//
//  Deck.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//         A deck of cards with mainboard / sideboard / maybeboard. Inherits shared fields
//         from Collection. Card-data statistics live in the linked CollectionStats (kept
//         current by StatsUpdater); `isLegal` is also maintained there since a CardEntry no
//         longer carries legality data directly. Quantity-based counts stay computed.
//  External Types:
//         CardEntry, Collection, CollectionStats

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@available(iOS 26, *)
@Model
final class Deck: Collection {

    // MARK: Stored Properties

    var ruleType: String = "casual"

    /// Maintained by StatsUpdater (needs card legality data, which lives in CardCache).
    var isLegal: Bool = true

    /// The deck's colour identity (WUBRG). Auto-set from the leader(s) whenever one is designated,
    /// and always editable by hand in the deck's edit sheet. See `DeckColors`.
    var colorIdentity: [String] = []

    /// Board backing stores — optional because CloudKit requires to-many relationships to be
    /// optional. Each has its own inverse on CardEntry. The rest of the app uses the non-optional
    /// `mainboard`/`sideboard`/`maybeboard` facades below.
    @Relationship(deleteRule: .cascade, inverse: \CardEntry.deckMainboard) var mainboardStore: [CardEntry]?
    @Relationship(deleteRule: .cascade, inverse: \CardEntry.deckSideboard) var sideboardStore: [CardEntry]?
    @Relationship(deleteRule: .cascade, inverse: \CardEntry.deckMaybeboard) var maybeboardStore: [CardEntry]?

    /// Non-optional accessors so existing code reads / appends / removeAll without unwrapping.
    /// (Computed → not persisted; SwiftData only stores the `*Store` relationships.)
    var mainboard: [CardEntry] {
        get { mainboardStore ?? [] }
        set { mainboardStore = newValue }
    }
    var sideboard: [CardEntry] {
        get { sideboardStore ?? [] }
        set { sideboardStore = newValue }
    }
    var maybeboard: [CardEntry] {
        get { maybeboardStore ?? [] }
        set { maybeboardStore = newValue }
    }

    // MARK: Leaders

    // A "leader" (commander / oathbreaker / signature spell) is an ordinary mainboard card flagged
    // with a `role`. The flag is purely presentational: the card is still counted in the mainboard's
    // stats and totals like any other card — it just renders in its leader widget instead of the
    // board grid. Nothing is moved to a separate store, so a leader is never lost or double-counted.

    /// Active leaders — mainboard cards with a role — ordered by the deck's rule-type slots then by
    /// when added (Oathbreaker before Signature Spell, etc.).
    var activeLeaders: [CardEntry] {
        let order = DeckRules.leaderSlots(for: ruleType).map(\.role)
        return mainboard.filter { !$0.isDeleted && !$0.role.isEmpty }.sorted {
            let l = order.firstIndex(of: $0.role) ?? Int.max
            let r = order.firstIndex(of: $1.role) ?? Int.max
            return l == r ? $0.dateAdded < $1.dateAdded : l < r
        }
    }

    /// Active leaders filling a specific slot.
    func leaders(role: String) -> [CardEntry] {
        mainboard.filter { $0.role == role && !$0.isDeleted }
    }

    /// Read-only compatibility shim for the many call sites that just want "the commander".
    var commander: CardEntry? { leaders(role: "commander").first }

    /// Flag a mainboard card as a leader in `slot`. The card stays in the mainboard (its data, stats
    /// and counts are unchanged) — only where it displays changes. Enforces the slot's max count by
    /// clearing the oldest occupant's flag. Moves the card into the mainboard if it was elsewhere.
    func setLeader(_ entry: CardEntry, slot: DeckLeaderSlot) {
        if !mainboard.contains(where: { $0.id == entry.id }) {
            sideboard.removeAll { $0.id == entry.id }
            maybeboard.removeAll { $0.id == entry.id }
            mainboard.append(entry)
        }
        // Enforce capacity — bump the oldest occupant back to a normal card.
        var sameRole = leaders(role: slot.role)
        while sameRole.count >= slot.maxCount, let oldest = sameRole.first {
            oldest.role = ""
            sameRole.removeFirst()
        }
        entry.role = slot.role
        entry.updatedAt = Date()
    }

    /// Clear a leader's flag — it returns to the mainboard grid (never deleted).
    func removeLeader(_ entry: CardEntry) {
        entry.role = ""
        entry.updatedAt = Date()
    }

    /// Clear every leader flag — used when the game mode changes, since the slots differ.
    func resetLeaders() {
        for entry in (mainboard + sideboard + maybeboard) where !entry.role.isEmpty {
            entry.role = ""
            entry.updatedAt = Date()
        }
    }

    /// Designate an imported card as a leader. Import formats express only a generic "Commander"
    /// slot, so map to the deck's primary slot (or `role` if supplied). Appends to the mainboard.
    func designateImportedLeader(_ entry: CardEntry, role: String? = nil) {
        if !mainboard.contains(where: { $0.id == entry.id }) { mainboard.append(entry) }
        let slots = DeckRules.leaderSlots(for: ruleType)
        let slot = role.flatMap { r in slots.first { $0.role == r } }
            ?? slots.first
            ?? DeckLeaderSlot(role: role ?? "commander", label: "Commander", maxCount: 2)
        setLeader(entry, slot: slot)
    }

    // MARK: Quantity-based Computed Properties (no card data needed)

    /// All active mainboard cards, leaders included — stats and counts treat a leader like any other
    /// card (the role only affects display).
    var activeMainboard: [CardEntry] {
        mainboard.filter { !$0.isDeleted }
    }

    var cardCount: Int {
        activeMainboard.reduce(0) { $0 + $1.quantity }
    }

    var uniqueCount: Int {
        activeMainboard.count
    }

    // Stats (price, land count, breakdowns) live in the local CollectionStats and are read via
    // StatsStore.stats(for:context:) — they can't be computed on the model without a context.

    // MARK: Initializer

    init(name: String, notes: String = "", ruleType: String = "casual") {
        self.ruleType = ruleType
        super.init(name: name, notes: notes)
        // A deck is a build, not owned stock — exclude from whole-collection totals by default.
        self.inCollection = false
    }
}
