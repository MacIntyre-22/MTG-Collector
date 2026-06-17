//
//  MTG_CollectorApp.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-19.
//  Purpose:
//      Top level app struct. Builds a two-store ModelContainer:
//        • "Synced"  — lightweight user data (collections, card IDs, stats, settings).
//                      This is the store that will sync to CloudKit (Pro, Phase 6).
//        • "Cache"   — full card data (CardCache), local-only, never synced.
//      The two stores share NO relationships (CardEntry → card data is resolved by ID via
//      CardStore), which is what keeps synced data small and CloudKit-legal.
//  External Types:
//      Collection, Binder, Deck, CardEntry, CollectionStats, Settings, SetInfo, CardCache

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

@main
struct MTG_CollectorApp: App {

    // MARK: Stored Properties

    let container: ModelContainer

    // MARK: Initializer

    init() {
        do {
            // Synced store: only lightweight records travel to iCloud once sync is enabled.
            // No @Attribute(.unique) here — CloudKit-backed stores reject unique constraints.
            let syncedSchema = Schema([
                Collection.self,
                Binder.self,
                Deck.self,
                CardEntry.self,
                CollectionStats.self,
                Settings.self
            ])

            // Local-only store: full card data + set reference data (SetInfo uses .unique),
            // re-fetched from Scryfall per device. Never synced.
            let cacheSchema = Schema([CardCache.self, SetInfo.self])

            // iCloud sync follows the user's preference (stored in UserDefaults so it's readable
            // here, before the SwiftData Settings record exists). Default on; applies at launch.
            // Verify on a real device — the simulator is unreliable for CloudKit.
            let syncEnabled = UserDefaults.standard.object(forKey: "iCloudSyncEnabled") as? Bool ?? true
            let syncedConfig = ModelConfiguration(
                "Synced",
                schema: syncedSchema,
                cloudKitDatabase: syncEnabled ? .automatic : .none
            )
            let cacheConfig = ModelConfiguration("Cache", schema: cacheSchema, cloudKitDatabase: .none)

            container = try ModelContainer(
                for: AppSchema.fullSchema,
                migrationPlan: AppMigrationPlan.self,
                configurations: syncedConfig, cacheConfig
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    // MARK: View

    var body: some Scene {
        WindowGroup {
            MTG_TabView()
        }
        .modelContainer(container)
    }
}
