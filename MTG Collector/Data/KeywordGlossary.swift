//
//  KeywordGlossary.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      Loads the bundled KeywordGlossary.json (keyword → { type, definition }) once and looks up a
//      card's keywords. This is the detail panel's standout add — the card image can't explain what
//      "Ward" or "Convoke" does, so tapping a keyword chip reveals its rules here, labelled by which
//      kind of keyword it is (ability / action / ability word). Offline; expanding it is a one-line
//      JSON edit. Covers all of Scryfall's keyword-abilities, keyword-actions and ability-words.
//

// MARK: Imports

import Foundation

// MARK: Glossary

enum KeywordGlossary {

    /// Which family a keyword belongs to. Raw values match the JSON `type` field.
    enum KeywordType: String, Decodable {
        case ability                       // a property the card has (Flying, Ward…)
        case action                        // a verb a player performs (Scry, Mill…)
        case abilityWord = "ability_word"  // an italic flavour label with no rules of its own
    }

    /// A keyword's family plus its plain-language definition.
    struct Entry: Decodable {
        let type: KeywordType
        let definition: String
    }

    /// keyword (lowercased) → entry, loaded once from the bundled JSON.
    private static let map: [String: Entry] = load()

    /// The full entry (type + definition) for a keyword as Scryfall reports it (e.g. "First strike",
    /// "Ward"), or nil if it isn't in the glossary. Matched case-insensitively.
    static func entry(for keyword: String) -> Entry? {
        map[keyword.lowercased().trimmingCharacters(in: .whitespaces)]
    }

    /// Convenience: just the definition string, for callers that don't care about the type.
    static func definition(for keyword: String) -> String? {
        entry(for: keyword)?.definition
    }

    private static func load() -> [String: Entry] {
        guard let url = Bundle.main.url(forResource: "KeywordGlossary", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let catalog = try? JSONDecoder().decode(Catalog.self, from: data) else { return [:] }
        var out: [String: Entry] = [:]
        for (key, value) in catalog.keywords { out[key.lowercased()] = value }
        return out
    }

    private struct Catalog: Decodable {
        let version: Int
        let keywords: [String: Entry]
    }
}
