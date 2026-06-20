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
import CoreSpotlight

// MARK: Types

@main
struct MTG_CollectorApp: App {

    // MARK: Stored Properties

    /// Routes Home Screen quick actions (long-press the app icon) into AppRouter.
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    /// Shared two-store container (also used by App Intents that read collection data).
    let container = AppModelContainer.shared

    /// Shared navigation coordinator — also reachable by App Intents and Spotlight handlers.
    @State private var router = AppRouter.shared

    // MARK: Initializer

    init() {
        // Make the Erben Gothic "Cardhold" wordmark available app-wide.
        BrandFont.register()

        // Generous shared URL cache so card art and API JSON persist on disk between launches —
        // backs ImageCache and cuts repeat network work (a major source of UI lag).
        URLCache.shared = URLCache(memoryCapacity: 64 * 1024 * 1024,   // 64 MB RAM
                                   diskCapacity: 512 * 1024 * 1024)     // 512 MB disk

        // Start observing CloudKit sync events from launch so Settings can show real status.
        _ = CloudSyncMonitor.shared
    }

    // MARK: View

    var body: some Scene {
        WindowGroup {
            // Hold a brief splash while universal assets (symbol map + everyday pips) warm, so the
            // first screen draws instantly instead of rendering pips one by one. Capped internally.
            LaunchGate {
                MTG_TabView()
                    .environment(router)
                    // Spotlight result tapped → route to the indexed binder/deck.
                    .onContinueUserActivity(CSSearchableItemActionType) { activity in
                        Spotlight.handle(activity: activity, router: router)
                    }
            }
        }
        .modelContainer(container)
    }
}
