//
//  StatsStore.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Lookup layer for the local-only CollectionStats. Since stats no longer hang off a SwiftData
//      relationship (they live in the cache store, the synced Collection can't relate to them),
//      views and StatsUpdater fetch/create them by collection id through here. A small in-context
//      fetch — cheap, and the result is cached by SwiftData.
//  External Types:
//      CollectionStats, Collection
//

// MARK: Imports

import Foundation
import SwiftData

// MARK: Store

@MainActor
enum StatsStore {

    /// The stored stats for a collection id, if they've been computed yet.
    static func stats(for collectionID: String, context: ModelContext) -> CollectionStats? {
        guard !collectionID.isEmpty else { return nil }
        var descriptor = FetchDescriptor<CollectionStats>(
            predicate: #Predicate { $0.collectionID == collectionID }
        )
        descriptor.fetchLimit = 1
        return try? context.fetch(descriptor).first
    }

    /// The stored stats for a collection.
    static func stats(for collection: Collection, context: ModelContext) -> CollectionStats? {
        stats(for: collection.id, context: context)
    }

    /// Fetch the existing stats row for a collection, or create + insert a new one.
    static func ensure(for collectionID: String, context: ModelContext) -> CollectionStats {
        if let existing = stats(for: collectionID, context: context) { return existing }
        let created = CollectionStats(collectionID: collectionID)
        context.insert(created)
        return created
    }

    /// Remove the stats row for a deleted collection (call when a binder/deck is deleted).
    static func remove(for collectionID: String, context: ModelContext) {
        if let existing = stats(for: collectionID, context: context) {
            context.delete(existing)
        }
    }
}
