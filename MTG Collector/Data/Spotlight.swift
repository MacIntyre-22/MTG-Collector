//
//  Spotlight.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-30.
//  Purpose:
//      Indexes the user's binders and decks into CoreSpotlight so they appear in iOS Search,
//      and routes a tapped result back into the app (via AppRouter) by parsing the typed
//      identifier it stored at index time.
//  External Types:
//      AppRouter
//

// MARK: Imports

import CoreSpotlight
import UIKit

// MARK: Types

struct Spotlight {

    /// The kind of collection a Spotlight item points at. Encoded into the item identifier so a
    /// tapped result can be routed to the right view.
    enum Kind: String {
        case binder
        case deck
    }

    /// Domain all Cardhold items share, so the whole index can be cleared in one call if needed.
    private static let domain = "net.benmacintyre.cardhold.collection"

    // MARK: Indexing

    /// Index (or re-index) a binder or deck. The identifier is `kind-id` so taps can be routed.
    static func index(kind: Kind, id: String, name: String, image: UIImage?, description: String) {
        let attributes = CSSearchableItemAttributeSet(contentType: .text)
        attributes.title = name
        attributes.contentDescription = description
        attributes.keywords = ["Deck", "Binder", "Collection", "Cards", "MTG", "Magic", name]
        if let image, let data = image.pngData() {
            attributes.thumbnailData = data
        }

        let item = CSSearchableItem(
            uniqueIdentifier: "\(kind.rawValue)-\(id)",
            domainIdentifier: domain,
            attributeSet: attributes
        )
        CSSearchableIndex.default().indexSearchableItems([item])
    }

    /// Remove a binder or deck from the index (call on delete).
    static func remove(kind: Kind, id: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(kind.rawValue)-\(id)"])
    }

    // MARK: Handling

    /// Route a tapped Spotlight result back into the app.
    static func handle(activity: NSUserActivity, router: AppRouter) {
        guard let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
        // Identifier is "kind-rawID"; split on the first hyphen since UUIDs contain hyphens too.
        guard let dash = identifier.firstIndex(of: "-") else { return }
        let kindRaw = String(identifier[..<dash])
        let id = String(identifier[identifier.index(after: dash)...])

        switch Kind(rawValue: kindRaw) {
        case .binder: router.openBinder(id: id)
        case .deck:   router.openDeck(id: id)
        case .none:   break
        }
    }
}
