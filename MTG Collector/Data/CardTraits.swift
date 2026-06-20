//
//  CardTraits.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      Detects notable traits on a card (Alchemy rebalanced, Reserved List, and card-type layouts
//      like split / adventure / saga) and returns them as InfoDetails for the detail panel's pill
//      row. Detection is here (name prefix / reserved flag / Scryfall layout); the display text and
//      colours live in the bundled CardTraits.json. Adding a trait = one JSON entry + one line here.
//  External Types:
//      Card, InfoDetail
//

// MARK: Imports

import SwiftUI

// MARK: - Traits

enum CardTraits {

    /// The trait pills to show for a card, in a stable order (markers first, then card type).
    static func traits(for card: Card) -> [InfoDetail] {
        var ids: [String] = []

        // Special markers.
        if card.name.hasPrefix("A-") { ids.append("alchemy") }
        if card.reserved { ids.append("reserved") }

        // Card-type layout (one at most).
        switch card.layout {
        case "transform", "modal_dfc", "reversible_card", "double_faced_token":
            ids.append("double_faced")
        case "split":     ids.append("split")
        case "adventure": ids.append("adventure")
        case "flip":      ids.append("flip")
        case "saga":      ids.append("saga")
        case "class":     ids.append("class")
        default:          break
        }

        return ids.compactMap { detail(for: $0) }
    }

    // MARK: Lookup

    private static func detail(for id: String) -> InfoDetail? {
        guard let t = map[id] else { return nil }
        return InfoDetail(
            id: id,
            symbol: t.icon,
            title: t.label,
            category: t.category,
            categoryIcon: nil,            // the title label already carries the trait icon
            tint: color(t.tint),
            blurb: nil,
            definition: t.definition
        )
    }

    /// trait id → entry, loaded once from the bundled JSON.
    private static let map: [String: Trait] = load()

    private static func load() -> [String: Trait] {
        guard let url = Bundle.main.url(forResource: "CardTraits", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let catalog = try? JSONDecoder().decode(Catalog.self, from: data) else { return [:] }
        return catalog.traits
    }

    private static func color(_ name: String) -> Color {
        switch name {
        case "indigo": return .indigo
        case "orange": return .orange
        case "teal":   return .teal
        case "blue":   return .blue
        case "purple": return .purple
        case "green":  return .green
        case "red":    return .red
        case "pink":   return .pink
        case "mint":   return .mint
        case "cyan":   return .cyan
        case "brown":  return .brown
        default:       return .secondary
        }
    }

    // MARK: JSON

    private struct Catalog: Decodable {
        let version: Int
        let traits: [String: Trait]
    }

    private struct Trait: Decodable {
        let label: String
        let icon: String
        let category: String
        let tint: String
        let definition: String
    }
}
