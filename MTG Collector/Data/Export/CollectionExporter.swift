//
//  CollectionExporter.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Pure exporters that turn a collection's CardEntry records into shareable text. Plain
//      text matches the format Moxfield / Archidekt / TappedOut import (round-trips with the
//      DeckImportParser); CSV is for spreadsheets. Card names/sets are looked up from a
//      [scryfallCardID: Card] map since a CardEntry stores only an ID. No SwiftUI / SwiftData.
//  External Types:
//      CardEntry, Deck, Card

// MARK: Imports

import Foundation

// MARK: Exporter

enum CollectionExporter {

    // MARK: Plain text

    /// "4 Lightning Bolt" lines for a flat list (binder / general collection).
    static func plainText(_ entries: [CardEntry], lookup: [String: Card]) -> String {
        active(entries).map { line(for: $0, lookup: lookup) }.joined(separator: "\n")
    }

    /// Sectioned deck list (Commander / Deck / Sideboard / Maybeboard) — Moxfield compatible.
    static func deckText(_ deck: Deck, lookup: [String: Card]) -> String {
        var sections: [String] = []

        if let commander = deck.commander, !commander.isDeleted {
            sections.append("Commander\n" + line(for: commander, lookup: lookup))
        }
        if !active(deck.mainboard).isEmpty {
            sections.append("Deck\n" + plainText(deck.mainboard, lookup: lookup))
        }
        if !active(deck.sideboard).isEmpty {
            sections.append("Sideboard\n" + plainText(deck.sideboard, lookup: lookup))
        }
        if !active(deck.maybeboard).isEmpty {
            sections.append("Maybeboard\n" + plainText(deck.maybeboard, lookup: lookup))
        }

        return sections.joined(separator: "\n\n")
    }

    // MARK: CSV

    /// CSV with header: Quantity,Name,Set,Foil
    static func csv(_ entries: [CardEntry], lookup: [String: Card]) -> String {
        var rows = ["Quantity,Name,Set,Foil"]
        for entry in active(entries) {
            let card = lookup[entry.scryfallCardID]
            let name = card?.name ?? entry.scryfallCardID
            let set = card?.set.uppercased() ?? ""
            let foil = entry.isFoil ? "Foil" : ""
            rows.append("\(entry.quantity),\(escape(name)),\(escape(set)),\(foil)")
        }
        return rows.joined(separator: "\n")
    }

    // MARK: Helpers

    private static func active(_ entries: [CardEntry]) -> [CardEntry] {
        entries.filter { !$0.isDeleted }
    }

    private static func line(for entry: CardEntry, lookup: [String: Card]) -> String {
        let name = lookup[entry.scryfallCardID]?.name ?? entry.scryfallCardID
        return "\(entry.quantity) \(name)"
    }

    /// RFC-4180 CSV escaping: wrap in quotes + double internal quotes when needed.
    private static func escape(_ field: String) -> String {
        guard field.contains(",") || field.contains("\"") || field.contains("\n") else {
            return field
        }
        return "\"" + field.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}
