//
//  AppSchema.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Versioned schema + migration plan scaffold. Phase 2's data model IS the v1 schema —
//      this file pins it as SchemaV1 so that every future model change becomes SchemaV2,
//      SchemaV3, … with explicit migration stages. Without this, any model change after v1
//      ships would crash existing users and wipe their collection.
//
//      IMPORTANT: do not ship to the App Store until this schema is finalised and verified
//      on a real device (especially once CloudKit is enabled).
//  External Types:
//      Collection, Binder, Deck, CardEntry, CollectionStats, Settings, SetInfo, CardCache

// MARK: Imports

import Foundation
import SwiftData

// MARK: Versioned Schema

enum SchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [
            Collection.self,
            Binder.self,
            Deck.self,
            CardEntry.self,
            CollectionStats.self,
            Settings.self,
            SetInfo.self,
            CardCache.self
        ]
    }
}

// MARK: Convenience

enum AppSchema {
    /// Full union schema across both stores (synced + local cache).
    static var fullSchema: Schema {
        Schema(SchemaV1.models)
    }
}

// MARK: Migration Plan

/// No migration stages yet — V1 is the initial shipping schema. When the model changes,
/// add SchemaV2 above and a `.lightweight`/`.custom` stage here mapping V1 → V2.
enum AppMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self]
    }

    static var stages: [MigrationStage] {
        []
    }
}
