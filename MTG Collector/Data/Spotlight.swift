//
//  Spotlight.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-10-30.
//  Purpose:
//         Handles Spotlight (CoreSpotlight) indexing so binders and decks appear in iOS
//         Search. Indexing is kept in sync on create / edit / delete; tapping a result is
//         routed through SpotlightRouter.
//  External Types:
//         SpotlightRouter

// MARK: Imports

import CoreSpotlight
import UIKit

// MARK: Types

struct Spotlight {

    /// Domain used for all of our searchable items.
    static let domain = "mtgcollector"

    // MARK: Indexing

    /// Index (or re-index) a binder or deck so it appears in iOS Search.
    static func indexData(id: String, name: String, image: UIImage?, description: String) {
        let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
        attributeSet.title = name
        attributeSet.contentDescription = description
        attributeSet.keywords = ["Deck", "Binder", "Collection", "Cards", "Magic", "Magic The Gathering", name]
        if let image, let data = image.pngData() {
            attributeSet.thumbnailData = data
        }

        let item = CSSearchableItem(uniqueIdentifier: id, domainIdentifier: domain, attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { _ in }
    }

    // MARK: De-indexing

    /// Remove a single item from the index (call before deleting a binder/deck).
    static func deindex(id: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id]) { _ in }
    }

    /// Remove everything we indexed (used by Delete All Data).
    static func deindexAll() {
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [domain]) { _ in }
    }

    // MARK: Handle Spotlight tap

    /// Extracts the tapped item's unique identifier from its continuation activity.
    static func identifier(from userActivity: NSUserActivity) -> String? {
        guard userActivity.activityType == CSSearchableItemActionType else { return nil }
        return userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String
    }
}
