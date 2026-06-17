//
//  CardStore.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//         Resolves CardEntry IDs into full Card data via the local CardCache. On a cache
//         miss the card is fetched from Scryfall and cached. This is the single bridge
//         between lightweight synced records (CardEntry / scryfallCardID) and the card
//         details the UI needs.
//  External Types:
//         CardCache, Card, SFAPI

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@MainActor
enum CardStore {

    // MARK: Cache Lookups

    /// Synchronous cache-only lookup. Returns nil on a miss.
    static func cached(_ id: String, context: ModelContext) -> Card? {
        guard !id.isEmpty else { return nil }
        var descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { $0.scryfallCardID == id })
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first?.card
    }

    /// Cache-only lookup for many IDs at once. Missing IDs are simply absent from the result.
    static func lookup(for ids: [String], context: ModelContext) -> [String: Card] {
        // Array (not Set) — SwiftData #Predicate supports `[T].contains`.
        let wanted = Array(Set(ids.filter { !$0.isEmpty }))
        guard !wanted.isEmpty else { return [:] }

        let descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { wanted.contains($0.scryfallCardID) })
        let entries = (try? context.fetch(descriptor)) ?? []

        var result: [String: Card] = [:]
        for entry in entries {
            result[entry.scryfallCardID] = entry.card
        }
        return result
    }

    // MARK: Resolution

    /// Resolve a card by ID: cache hit, otherwise fetch from Scryfall and cache it.
    @discardableResult
    static func resolve(_ id: String, context: ModelContext) async -> Card? {
        if let hit = cached(id, context: context) { return hit }
        guard let json = await SFAPI.fetchCardId(id: id) else { return nil }
        let card = SFAPI.JSONtoModel(json: json)
        cache(card, context: context)
        return card
    }

    // MARK: Caching

    /// Insert a new cache entry or refresh an existing one (updating fetchedAt).
    static func cache(_ card: Card, context: ModelContext) {
        guard !card.id.isEmpty else { return }
        let id = card.id
        var descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { $0.scryfallCardID == id })
        descriptor.fetchLimit = 1

        if let existing = (try? context.fetch(descriptor))?.first {
            existing.card = card
            existing.fetchedAt = Date()
        } else {
            context.insert(CardCache(card: card))
        }
    }

    /// Cache a batch of cards (e.g. from a /cards/collection resolve).
    static func cache(_ cards: [Card], context: ModelContext) {
        for card in cards {
            cache(card, context: context)
        }
    }
}
