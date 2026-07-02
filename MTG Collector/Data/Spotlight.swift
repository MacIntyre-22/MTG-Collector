//
//  Spotlight.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-30.
//  Purpose:
//      Indexes the user's binders, decks and favourite cards into CoreSpotlight so they appear in
//      iOS Search, and routes a tapped result back into the app (via AppRouter) by parsing the
//      typed identifier it stored at index time. Collection covers are indexed as square thumbnails;
//      cards keep the Scryfall card proportions so the art reads correctly in the result row.
//  External Types:
//      AppRouter
//

// MARK: Imports

import CoreSpotlight
import UIKit

// MARK: Types

struct Spotlight {

    /// The kind of item a Spotlight entry points at. Encoded into the item identifier so a tapped
    /// result can be routed to the right view.
    enum Kind: String {
        case binder
        case deck
        case card
    }

    /// Domain all Cardhold items share, so the whole index can be cleared in one call if needed.
    private static let domain = "net.benmacintyre.cardhold.collection"

    // MARK: Indexing — collections

    /// Index (or re-index) a binder or deck. The identifier is `kind-id` so taps can be routed.
    /// The cover is stored as a centre-cropped square so it fills Spotlight's thumbnail slot cleanly.
    /// `rankingHint` biases more important collections (e.g. pinned) higher in results.
    static func index(kind: Kind, id: String, name: String, image: UIImage?,
                      description: String, keywords: [String] = [], rankingHint: Double? = nil) {
        let attributes = CSSearchableItemAttributeSet(contentType: .text)
        attributes.title = name
        attributes.contentDescription = description
        attributes.keywords = ["Deck", "Binder", "Collection", "Cards", "MTG", "Magic", name] + keywords
        if let image, let data = squareThumbnail(image) {
            attributes.thumbnailData = data
        }
        if let rankingHint {
            attributes.rankingHint = NSNumber(value: rankingHint)
        }

        let item = CSSearchableItem(
            uniqueIdentifier: "\(kind.rawValue)-\(id)",
            domainIdentifier: domain,
            attributeSet: attributes
        )
        CSSearchableIndex.default().indexSearchableItems([item])
    }

    // MARK: Indexing — cards

    /// Index (or re-index) a single card by its Scryfall id. The art keeps the card's portrait
    /// proportions (no square crop) so the full card shows in the result.
    static func indexCard(id: String, name: String, description: String,
                          keywords: [String] = [], image: UIImage?) {
        let attributes = CSSearchableItemAttributeSet(contentType: .text)
        attributes.title = name
        attributes.contentDescription = description
        attributes.keywords = ["Card", "MTG", "Magic", name] + keywords
        if let image, let data = cardThumbnail(image) {
            attributes.thumbnailData = data
        }

        let item = CSSearchableItem(
            uniqueIdentifier: "\(Kind.card.rawValue)-\(id)",
            domainIdentifier: domain,
            attributeSet: attributes
        )
        CSSearchableIndex.default().indexSearchableItems([item])
    }

    // MARK: Removal

    /// Remove a binder or deck from the index (call on delete).
    static func remove(kind: Kind, id: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(kind.rawValue)-\(id)"])
    }

    /// Remove a set of cards from the index (e.g. cards that are no longer favourited).
    static func removeCards(ids: [String]) {
        guard !ids.isEmpty else { return }
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ids.map { "\(Kind.card.rawValue)-\($0)" })
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
        case .card:   router.openCard(id: id)
        case .none:   break
        }
    }

    // MARK: Thumbnail helpers

    /// Centre-crop to a square and downscale — keeps the Spotlight index light and gives binders/
    /// decks a thumbnail that fills the (square) slot instead of being letterboxed.
    private static func squareThumbnail(_ image: UIImage, side: CGFloat = 180) -> Data? {
        let minSide = min(image.size.width, image.size.height)
        guard minSide > 0, let cg = image.cgImage else { return image.pngData() }
        let scale = image.scale
        let cropPx = CGRect(
            x: (image.size.width - minSide) / 2 * scale,
            y: (image.size.height - minSide) / 2 * scale,
            width: minSide * scale,
            height: minSide * scale
        )
        guard let cropped = cg.cropping(to: cropPx) else { return image.pngData() }
        let square = UIImage(cgImage: cropped, scale: scale, orientation: image.imageOrientation)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: side, height: side))
        return renderer.image { _ in
            square.draw(in: CGRect(x: 0, y: 0, width: side, height: side))
        }.pngData()
    }

    /// Downscale to a small thumbnail while preserving the card's portrait proportions.
    private static func cardThumbnail(_ image: UIImage, width: CGFloat = 150) -> Data? {
        guard image.size.width > 0 else { return image.pngData() }
        let height = width * (image.size.height / image.size.width)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        return renderer.image { _ in
            image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        }.pngData()
    }
}
