//
//  FormatGlossary.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      Beginner-facing explainers for deck formats, surfaced when the legality badge is tapped. The
//      format descriptions live in the bundled FormatGlossary.json; this builds an InfoDetail for a
//      deck's rule type and appends a plain-language note on what its Legal / Not-Legal status means.
//  External Types:
//      InfoDetail
//

// MARK: Imports

import SwiftUI

// MARK: - Glossary

enum FormatGlossary {

    /// The info-sheet model for a deck's format + its current legality result. Always returns a
    /// detail (unknown formats use a generic description), so the badge can always explain itself.
    static func infoDetail(ruleType: String, isLegal: Bool) -> InfoDetail {
        let key = ruleType.lowercased().trimmingCharacters(in: .whitespaces)
        let entry = map[key]
        let title = entry?.label ?? ruleType.capitalized
        let formatText = entry?.definition
            ?? "A constructed format with its own legal card pool and deckbuilding rules."

        let legalNote = isLegal
            ? "\n\nThis deck currently reads as Legal: every card is allowed in \(title) and it meets the format's deckbuilding rules."
            : "\n\nThis deck currently reads as Not Legal: one or more cards are banned, restricted, or outside \(title)'s card pool, or the deck doesn't meet the format's rules."

        return InfoDetail(
            id: "format.\(key)",
            symbol: isLegal ? "checkmark.seal.fill" : "exclamationmark.triangle.fill",
            title: title,
            category: "Format",
            categoryIcon: nil,
            tint: isLegal ? .statusGreen : .statusRed,
            blurb: nil,
            definition: formatText + legalNote
        )
    }

    // MARK: Lookup

    private static let map: [String: Format] = load()

    private static func load() -> [String: Format] {
        guard let url = Bundle.main.url(forResource: "FormatGlossary", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let catalog = try? JSONDecoder().decode(Catalog.self, from: data) else { return [:] }
        var out: [String: Format] = [:]
        for (key, value) in catalog.formats { out[key.lowercased()] = value }
        return out
    }

    private struct Catalog: Decodable {
        let version: Int
        let formats: [String: Format]
    }

    private struct Format: Decodable {
        let label: String
        let definition: String
    }
}
