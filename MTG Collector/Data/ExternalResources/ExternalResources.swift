//
//  ExternalResources.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Centralised source of external links (Scryfall, EDHREC, Gatherer, TCGPlayer, Cardmarket,
//      CardHoarder, MTGGoldfish, Moxfield). The calling screen passes a context and gets back
//      only the resources that actually have a URL, so the reusable ExternalResourcesWidget can
//      render them anywhere. Most links come straight from Scryfall fields fetched in Phase 2;
//      a few are hardcoded URL templates for sites Scryfall doesn't link.
//  External Types:
//      Card

// MARK: Imports

import Foundation

// MARK: Resource

struct ExternalResource: Identifiable {
    let id = UUID()
    let title: String
    let iconSystemName: String
    let url: URL
}

// MARK: Context

/// What the calling screen is showing — determines which resources are relevant.
enum ExternalResourcesContext {
    case card(Card)
    case commander(Card)
    case deck
    case binder
}

// MARK: Manager

enum ExternalResourcesManager {

    /// Returns the relevant, available resources for a context (empty URLs are skipped).
    static func resources(for context: ExternalResourcesContext) -> [ExternalResource] {
        switch context {
        case .card(let card):
            return cardResources(card)
        case .commander(let card):
            return commanderResources(card)
        case .deck:
            return deckResources()
        case .binder:
            return binderResources()
        }
    }

    // MARK: Per-context builders

    private static func cardResources(_ card: Card) -> [ExternalResource] {
        var items: [(String, String, String)] = [
            ("Scryfall", "doc.text.magnifyingglass", card.scryfallURI),
            ("EDHREC", "chart.bar.fill", card.relatedURIs.edhrec),
            ("Gatherer", "books.vertical.fill", card.relatedURIs.gatherer),
            ("TCGPlayer", "cart.fill", card.purchaseURIs.tcgplayer),
            ("Cardmarket", "eurosign.circle.fill", card.purchaseURIs.cardmarket),
            ("CardHoarder", "bag.fill", card.purchaseURIs.cardhoarder)
        ]
        // MTGGoldfish price page (hardcoded search template — not in Scryfall data)
        if !card.name.isEmpty {
            items.append(("MTGGoldfish", "fish.fill", mtgGoldfishSearch(card.name)))
        }
        return build(items)
    }

    private static func commanderResources(_ card: Card) -> [ExternalResource] {
        // The commander's own EDHREC page (the card's edhrec link).
        build([
            ("EDHREC Commander", "crown.fill", card.relatedURIs.edhrec),
            ("Scryfall", "doc.text.magnifyingglass", card.scryfallURI)
        ])
    }

    private static func deckResources() -> [ExternalResource] {
        build([
            ("EDHREC", "chart.bar.fill", "https://edhrec.com/"),
            ("MTGGoldfish Meta", "fish.fill", "https://www.mtggoldfish.com/metagame/"),
            ("Moxfield", "rectangle.stack.fill", "https://www.moxfield.com/")
        ])
    }

    private static func binderResources() -> [ExternalResource] {
        build([
            ("TCGPlayer", "cart.fill", "https://www.tcgplayer.com/"),
            ("Cardmarket", "eurosign.circle.fill", "https://www.cardmarket.com/")
        ])
    }

    // MARK: Helpers

    /// Turns (title, icon, urlString) tuples into resources, skipping any with no valid URL.
    private static func build(_ items: [(String, String, String)]) -> [ExternalResource] {
        items.compactMap { title, icon, urlString in
            guard !urlString.isEmpty, let url = URL(string: urlString) else { return nil }
            return ExternalResource(title: title, iconSystemName: icon, url: url)
        }
    }

    private static func mtgGoldfishSearch(_ name: String) -> String {
        let q = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "https://www.mtggoldfish.com/q?query_string=\(q)"
    }
}
