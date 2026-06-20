//
//  AppRouter.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Central navigation coordinator. A single shared instance drives which tab is shown and
//      carries deep-link intents (search a card, open a binder/deck, launch the scanner) from
//      outside the view tree — Spotlight taps and App Intents / Siri Shortcuts — into the UI.
//      Views observe it and react; the router never touches SwiftData itself.
//  External Types:
//      MTG_TabView, SearchTabView, MyCollectionTabView, Spotlight, CardholdShortcuts
//

// MARK: Imports

import SwiftUI

// MARK: Tabs

/// The app's top-level tabs. Raw values are the TabView selection tags.
enum AppTab: Int, Hashable {
    case home = 0
    case search = 1
    case collection = 2
    case settings = 3
}

// MARK: Router

@Observable
final class AppRouter {

    /// Shared instance so out-of-tree callers (App Intents, Spotlight handlers) can route without
    /// needing the SwiftUI environment. The app injects this same instance into the environment.
    static let shared = AppRouter()

    // MARK: Navigation State

    /// Currently selected tab (bound to the TabView).
    var selectedTab: AppTab = .home

    /// Set to request the Search tab's search field be focused (keyboard up, ready to type).
    var focusSearch: Bool = false

    /// Set to request the card scanner be opened on the Search tab.
    var pendingScan: Bool = false

    /// A binder id to push on the Collection tab. MyCollectionTabView resolves and clears it.
    var pendingBinderID: String?

    /// A deck id to push on the Collection tab. MyCollectionTabView resolves and clears it.
    var pendingDeckID: String?

    private init() {}

    // MARK: Intents

    /// Switch to Search and focus the search field so the user can start typing immediately.
    func openSearch() {
        focusSearch = true
        selectedTab = .search
    }

    /// Switch to Search and open the card scanner.
    func scanCard() {
        pendingScan = true
        selectedTab = .search
    }

    /// Switch to the Collection tab and push the given binder.
    func openBinder(id: String) {
        pendingBinderID = id
        selectedTab = .collection
    }

    /// Switch to the Collection tab and push the given deck.
    func openDeck(id: String) {
        pendingDeckID = id
        selectedTab = .collection
    }

    /// Switch to the Collection tab to surface the whole-collection summary.
    func showCollection() {
        selectedTab = .collection
    }
}
