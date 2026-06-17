//
//  ExternalResources.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      The External Resources engine (Extended Phase 2). A pure, stateless builder that turns a
//      context (card / commander / deck / binder) into the list of relevant outbound links. Sources
//      links from the Scryfall fields already stored on Card (scryfall_uri, related_uris,
//      purchase_uris) and from hardcoded URL templates for sites Scryfall doesn't link.
//  External Types:
//      Card, Deck, Binder, RelatedURIs, PurchaseURIs
//

// MARK: Imports

import Foundation

// MARK: Icon

/// How a resource row draws its leading glyph: a bundled brand asset, or an SF Symbol fallback.
enum ResourceIcon: Hashable {
    case asset(String)
    case symbol(String)
}

// MARK: Resource

struct ExternalResource: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: ResourceIcon
    let url: URL
}

// MARK: Context

/// What the calling screen is showing — determines which resources are relevant.
enum ExternalResourcesContext {
    case card(Card)
    case commander(Card)
    case deck(Deck)
    case binder(Binder)
}

// MARK: Manager

enum ExternalResourcesManager {

    /// All relevant resources for a context, with any missing-URL entries dropped.
    static func resources(for context: ExternalResourcesContext) -> [ExternalResource] {
        switch context {
        case .card(let card):           return cardResources(card)
        case .commander(let card):      return commanderResources(card)
        case .deck(let deck):           return deckResources(deck)
        case .binder(let binder):       return binderResources(binder)
        }
    }

    // MARK: Per-context builders

    private static func cardResources(_ card: Card) -> [ExternalResource] {
        [
            make("Scryfall Page", .symbol("magnifyingglass.circle.fill"), card.scryfallURI),
            make("EDHREC", .symbol("chart.bar.doc.horizontal.fill"), card.relatedURIs.edhrec),
            make("Gatherer", .symbol("books.vertical.fill"), card.relatedURIs.gatherer),
            make("TCGPlayer", .asset("TcgPlayer"), card.purchaseURIs.tcgplayer),
            make("Cardmarket", .asset("CardMarket"), card.purchaseURIs.cardmarket),
            make("CardHoarder", .asset("CardHoarder"), card.purchaseURIs.cardhoarder),
            make("TCGPlayer Decks", .symbol("rectangle.stack.fill"), card.relatedURIs.tcgplayerInfiniteDecks)
        ].compactMap { $0 }
    }

    private static func commanderResources(_ card: Card) -> [ExternalResource] {
        // For a legendary creature, Scryfall's related EDHREC link is its commander page.
        [
            make("EDHREC Commander Page", .symbol("crown.fill"), card.relatedURIs.edhrec),
            make("Scryfall Page", .symbol("magnifyingglass.circle.fill"), card.scryfallURI)
        ].compactMap { $0 }
    }

    private static func deckResources(_ deck: Deck) -> [ExternalResource] {
        let name = deck.name
        return [
            make("MTGGoldfish Meta", .symbol("fish.fill"), "https://www.mtggoldfish.com/q?query_name=\(encode(name))"),
            make("Moxfield", .symbol("square.stack.3d.up.fill"), "https://www.moxfield.com/decks/public?q=\(encode(name))")
        ].compactMap { $0 }
    }

    private static func binderResources(_ binder: Binder) -> [ExternalResource] {
        [
            make("TCGPlayer", .asset("TcgPlayer"), "https://www.tcgplayer.com/massentry"),
            make("Cardmarket", .asset("CardMarket"), "https://www.cardmarket.com/en/Magic")
        ].compactMap { $0 }
    }

    // MARK: Helpers

    /// Builds a resource, returning nil when the URL is empty or invalid so callers can drop it.
    private static func make(_ title: String, _ icon: ResourceIcon, _ urlString: String) -> ExternalResource? {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return nil }
        return ExternalResource(title: title, icon: icon, url: url)
    }

    private static func encode(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
