//
//  PriceRefresher.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      Keeps cached card prices current. When a collection screen appears it refreshes the cards
//      whose CardCache.fetchedAt is older than the interval (Scryfall prices update ~daily), batching
//      via /cards/collection (75 at a time) and re-caching (which updates the price data + fetchedAt).
//      Returns how many cards were refreshed so the screen can update its stats and show a banner.
//      A dev flag (Settings → Developer) forces a refresh on every open for testing.
//  External Types:
//      CardCache, CardStore, SFAPI, CardIdentifierJSON
//

// MARK: Imports

import Foundation
import SwiftData

// MARK: Refresher

@MainActor
enum PriceRefresher {

    /// Re-fetch a card once its cached data is older than this (24h — Scryfall prices update ~daily).
    static let interval: TimeInterval = 24 * 60 * 60

    /// UserDefaults key for the dev "force refresh on every open" toggle.
    static let devForceKey = "devForcePriceRefresh"

    /// Refresh the cached cards among `ids` whose data is stale (or all of them, if `force`). Returns
    /// the number refreshed; a no-op (returns 0) when nothing is stale, so it's cheap to call on open.
    @discardableResult
    static func refresh(ids: [String], context: ModelContext, force: Bool = false) async -> Int {
        let unique = Array(Set(ids.filter { !$0.isEmpty }))
        guard !unique.isEmpty else { return 0 }

        // Which of these cards are cached and stale?
        let descriptor = FetchDescriptor<CardCache>(predicate: #Predicate { unique.contains($0.scryfallCardID) })
        let entries = (try? context.fetch(descriptor)) ?? []
        let cutoff = Date().addingTimeInterval(-interval)
        let staleIDs = entries.filter { force || $0.fetchedAt < cutoff }.map(\.scryfallCardID)
        guard !staleIDs.isEmpty else { return 0 }

        var refreshed = 0
        for start in stride(from: 0, to: staleIDs.count, by: 75) {
            let chunk = Array(staleIDs[start..<min(start + 75, staleIDs.count)])
            let identifiers = chunk.map { CardIdentifierJSON(id: $0) }
            let (found, _) = await SFAPI.fetchCardCollection(identifiers: identifiers)
            let cards = found.map(SFAPI.JSONtoModel)
            CardStore.cache(cards, context: context)   // updates card data + fetchedAt
            refreshed += cards.count
        }
        return refreshed
    }

    /// Refresh on entering a collection — honours the dev "force refresh" toggle.
    @discardableResult
    static func refreshCollection(ids: [String], context: ModelContext) async -> Int {
        await refresh(ids: ids, context: context, force: UserDefaults.standard.bool(forKey: devForceKey))
    }

    /// Dev test: force-refresh every cached card and return the count.
    @discardableResult
    static func refreshAll(context: ModelContext) async -> Int {
        let entries = (try? context.fetch(FetchDescriptor<CardCache>())) ?? []
        return await refresh(ids: entries.map(\.scryfallCardID), context: context, force: true)
    }
}
