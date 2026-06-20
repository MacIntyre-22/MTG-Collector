//
//  DeckRoles.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Heuristic "what does this card do" tagging for deck analysis — ramp, card draw, removal,
//      tutor, etc. The vocabulary lives in the bundled DeckRoles.json (Scryfall keyword names plus
//      oracle-text cues), so roles can be tuned or added without a code change; this file just loads
//      it and matches cards against it. Deck builders judge a list by how much of each role it runs,
//      so the deck stats sheet shows a quantity-weighted count per role.
//  External Types:
//      Card
//

// MARK: Imports

import SwiftUI

// MARK: Definitions

/// One role and the vocabulary that identifies it, decoded from DeckRoles.json.
struct DeckRoleDefinition: Decodable, Identifiable {
    /// Stable key (e.g. "ramp"). Don't rename once shipped.
    let id: String
    /// User-facing list label.
    let label: String
    /// Beginner-facing explainer shown when the role chip is tapped.
    var summary: String = ""
    /// Drop lands from this role (they're the mana base, not ramp).
    var excludeLands: Bool = false
    /// Scryfall keyword names that imply this role (matched case-insensitively against `card.keywords`).
    var keywords: [String] = []
    /// Oracle-text cues. A plain string is a substring match; a string with '|' requires ALL parts
    /// present (logical AND, e.g. "search your library|land").
    var text: [String] = []

    /// The tap-to-learn info-sheet model for this role.
    var infoDetail: InfoDetail {
        InfoDetail(
            id: "role.\(id)",
            symbol: "puzzlepiece.extension.fill",
            title: label,
            category: "Deck Role",
            categoryIcon: nil,
            tint: .blue,
            blurb: nil,
            definition: summary
        )
    }
}

private struct DeckRoleCatalog: Decodable {
    let version: Int
    let roles: [DeckRoleDefinition]
}

// MARK: Classifier

enum DeckRoleClassifier {

    /// The role catalogue, loaded once from the bundled JSON (empty if missing/corrupt).
    static let roles: [DeckRoleDefinition] = load()

    private static func load() -> [DeckRoleDefinition] {
        guard let url = Bundle.main.url(forResource: "DeckRoles", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let catalog = try? JSONDecoder().decode(DeckRoleCatalog.self, from: data)
        else { return [] }
        return catalog.roles
    }

    /// The role ids a single card fills. A card may match several (a removal spell that also draws).
    static func roles(for card: Card) -> Set<String> {
        let text = card.oracleText.lowercased()
        let cardKeywords = Set(card.keywords.map { $0.lowercased() })
        let isLand = card.typeLine.lowercased().contains("land")

        var result: Set<String> = []
        for role in roles where !(role.excludeLands && isLand) {
            // Structured keyword match (most reliable) — short-circuit if hit.
            if role.keywords.contains(where: { cardKeywords.contains($0.lowercased()) }) {
                result.insert(role.id)
                continue
            }
            // Oracle-text cues — '|' means every part must be present.
            let hit = role.text.contains { cue in
                cue.split(separator: "|").allSatisfy { text.contains($0) }
            }
            if hit { result.insert(role.id) }
        }
        return result
    }
}
