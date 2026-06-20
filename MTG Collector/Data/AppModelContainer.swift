//
//  AppModelContainer.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Single source of truth for the app's two-store ModelContainer (Synced + local Cache).
//      Both the App scene and any App Intent that needs to read collection data share this one
//      instance, so a Siri shortcut run in the background opens the same store the UI uses.
//  External Types:
//      Collection, Binder, Deck, CardEntry, CollectionStats, Settings, SetInfo, CardCache,
//      AppSchema, AppMigrationPlan
//

// MARK: Imports

import SwiftData
import Foundation
import os

// MARK: Container

enum AppModelContainer {

    private static let log = Logger(subsystem: "net.benmacintyre.cardhold", category: "Persistence")

    /// The shared container, built once. App Intents reach SwiftData through this.
    static let shared: ModelContainer = make()

    /// Build the two-store container: a Synced store (CloudKit-eligible, lightweight user data)
    /// and a local-only Cache store (full card data, never synced).
    ///
    /// If the CloudKit-backed store fails to load (e.g. a model CloudKit can't accept, or no iCloud
    /// account), we fall back to a local-only store so a sync problem never bricks the app — and the
    /// log tells us *which* failure it was: a CloudKit rejection (the local fallback then succeeds)
    /// vs. a stale on-disk store from a schema change (the local fallback also fails → reinstall).
    static func make() -> ModelContainer {
        // Synced store: only lightweight user data travels to iCloud. CollectionStats is NOT here —
        // it's derived data and lives in the local cache store instead.
        let syncedSchema = Schema([
            Collection.self,
            Binder.self,
            Deck.self,
            CardEntry.self,
            Settings.self
        ])
        // Local-only cache: full card data, set reference data, and derived collection stats.
        let cacheConfig = ModelConfiguration("Cache", schema: Schema([CardCache.self, SetInfo.self, CollectionStats.self]),
                                             cloudKitDatabase: .none)

        // iCloud sync is OPT-IN (default off) AND Pro-only. CloudKit is never engaged unless the user
        // both turned it on in Settings and is entitled. `isProEntitled` mirrors ProAccessManager into
        // UserDefaults (written each session) so this very early, pre-SwiftData build can read it.
        // Crash-proof: if the CloudKit store throws it falls back to local-only.
        let syncToggleOn = UserDefaults.standard.object(forKey: "iCloudSyncEnabled") as? Bool ?? false
        let proEntitled = UserDefaults.standard.bool(forKey: "isProEntitled")
        let syncEnabled = syncToggleOn && proEntitled

        if syncEnabled {
            let cloudConfig = ModelConfiguration("Synced", schema: syncedSchema, cloudKitDatabase: .automatic)
            if let container = try? ModelContainer(for: AppSchema.fullSchema,
                                                   migrationPlan: AppMigrationPlan.self,
                                                   configurations: cloudConfig, cacheConfig) {
                log.info("CloudKit store loaded.")
                return container
            }
            log.error("CloudKit store failed to load — falling back to local-only.")
        }

        let localConfig = ModelConfiguration("Synced", schema: syncedSchema, cloudKitDatabase: .none)
        do {
            return try ModelContainer(for: AppSchema.fullSchema,
                                      migrationPlan: AppMigrationPlan.self,
                                      configurations: localConfig, cacheConfig)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
