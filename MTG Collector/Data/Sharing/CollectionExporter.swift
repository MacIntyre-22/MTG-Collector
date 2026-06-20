//
//  CollectionExporter.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Pure text/CSV writers for a deck or binder. Given resolved export rows (quantity, name,
//      printing, foil, board) it produces a standard plain-text decklist (Moxfield / Archidekt /
//      Arena compatible) and a CSV. No SwiftUI / SwiftData / network, so it can be unit-tested and
//      reused by both the file-export and (later) share paths.
//  External Types:
//      DeckBoard
//

// MARK: Imports

import Foundation

// MARK: Row

/// One line of an export, already resolved against card data.
struct ExportRow {
    var quantity: Int
    var name: String
    var setCode: String       // may be empty if the printing is unknown
    var collectorNumber: String
    var isFoil: Bool
    /// nil for a binder (flat list); set for a deck so lines group under board headers.
    var board: DeckBoard?
}

// MARK: Exporter

enum CollectionExporter {

    // MARK: Plain text

    /// Standard decklist text. Lines are `"<qty> <name> (<SET>) <collector>"`, with Arena-style
    /// printing hints included only when known. A deck groups lines under `Commander` / `Sideboard`
    /// / `Maybeboard` headers (mainboard first, unheadered); a binder is a single flat list.
    static func text(rows: [ExportRow]) -> String {
        // Binder / no boards → flat list.
        guard rows.contains(where: { $0.board != nil }) else {
            return rows.map(textLine).joined(separator: "\n")
        }

        var out: [String] = []
        // Mainboard first with no header, then the others under headers (skip empties).
        let order: [(DeckBoard, String?)] = [
            (.mainboard, nil),
            (.commander, "Commander"),
            (.sideboard, "Sideboard"),
            (.maybeboard, "Maybeboard")
        ]
        for (board, header) in order {
            let group = rows.filter { ($0.board ?? .mainboard) == board }
            guard !group.isEmpty else { continue }
            if !out.isEmpty { out.append("") }       // blank line between sections
            if let header { out.append(header) }
            out.append(contentsOf: group.map(textLine))
        }
        return out.joined(separator: "\n")
    }

    private static func textLine(_ row: ExportRow) -> String {
        var line = "\(row.quantity) \(row.name)"
        if !row.setCode.isEmpty {
            line += " (\(row.setCode.uppercased()))"
            if !row.collectorNumber.isEmpty { line += " \(row.collectorNumber)" }
        }
        if row.isFoil { line += " *F*" }   // Moxfield/Archidekt foil marker
        return line
    }

    // MARK: CSV

    /// CSV with a header row. Columns chosen for broad compatibility with collection tools:
    /// `Quantity,Name,Set,Collector Number,Foil,Board`. Board is blank for binders.
    static func csv(rows: [ExportRow]) -> String {
        var lines = ["Quantity,Name,Set,Collector Number,Foil,Board"]
        for row in rows {
            let cols = [
                String(row.quantity),
                row.name,
                row.setCode.uppercased(),
                row.collectorNumber,
                row.isFoil ? "foil" : "",
                row.board?.rawValue ?? ""
            ]
            lines.append(cols.map(escapeCSV).joined(separator: ","))
        }
        return lines.joined(separator: "\n")
    }

    /// Quote a field if it contains a comma, quote or newline; double internal quotes.
    private static func escapeCSV(_ field: String) -> String {
        guard field.contains(",") || field.contains("\"") || field.contains("\n") else { return field }
        return "\"" + field.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}
