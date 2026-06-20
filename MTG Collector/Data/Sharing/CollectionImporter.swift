//
//  CollectionImporter.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Turns pasted text or a picked file into ParsedDeckLine values for the resolver. Plain text
//      goes through DeckImportParser; CSV is parsed here with a flexible header map so exports from
//      Cardhold, Moxfield, Archidekt, Deckbox, ManaBox etc. all load. Pure (no SwiftData/network):
//      the same lines feed both deck and binder import.
//  External Types:
//      DeckImportParser, ParsedDeckLine, DeckBoard
//

// MARK: Imports

import Foundation

// MARK: Format

enum ImportFormat {
    case text
    case csv
}

// MARK: Importer

enum CollectionImporter {

    /// Guess the format from a filename extension, falling back to sniffing the content (a header
    /// row with commas and a recognised column name → CSV).
    static func detectFormat(filename: String?, content: String) -> ImportFormat {
        if let ext = filename?.split(separator: ".").last?.lowercased() {
            if ext == "csv" { return .csv }
            if ext == "txt" || ext == "dec" { return .text }
        }
        let firstLine = content.components(separatedBy: .newlines).first?.lowercased() ?? ""
        if firstLine.contains(",") && (firstLine.contains("name") || firstLine.contains("quantity") || firstLine.contains("count")) {
            return .csv
        }
        return .text
    }

    /// Parse content into lines, auto-detecting the format if not given.
    static func parse(_ content: String, format: ImportFormat? = nil, filename: String? = nil) -> [ParsedDeckLine] {
        switch format ?? detectFormat(filename: filename, content: content) {
        case .text: return DeckImportParser().parse(content)
        case .csv:  return parseCSV(content)
        }
    }

    // MARK: CSV

    private static func parseCSV(_ content: String) -> [ParsedDeckLine] {
        var rows = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        guard !rows.isEmpty else { return [] }

        let header = splitCSVLine(rows.removeFirst()).map { normalise($0) }
        let map = ColumnMap(header: header)
        // No recognisable name column → not a CSV we can use.
        guard map.name != nil else { return [] }

        return rows.compactMap { line in
            let cols = splitCSVLine(line)
            func value(_ index: Int?) -> String {
                guard let index, index < cols.count else { return "" }
                return cols[index].trimmingCharacters(in: .whitespaces)
            }

            let name = value(map.name)
            guard !name.isEmpty else { return nil }

            let quantity = max(Int(value(map.quantity)) ?? 1, 1)
            let set = value(map.set)
            let collector = value(map.collector)
            let foil = isFoilValue(value(map.foil))
            let board = boardValue(value(map.board))

            return ParsedDeckLine(
                quantity: quantity,
                name: name,
                setCode: set.isEmpty ? nil : set,
                collectorNumber: collector.isEmpty ? nil : collector,
                board: board,
                isFoil: foil
            )
        }
    }

    // MARK: Column mapping

    /// Resolves known column names (across common exporters) to indices.
    private struct ColumnMap {
        let quantity: Int?
        let name: Int?
        let set: Int?
        let collector: Int?
        let foil: Int?
        let board: Int?

        init(header: [String]) {
            func find(_ names: [String]) -> Int? {
                header.firstIndex { names.contains($0) }
            }
            quantity  = find(["quantity", "count", "qty", "amount"])
            name      = find(["name", "card name", "card"])
            set       = find(["set", "set code", "edition", "edition code"])
            collector = find(["collector number", "collector #", "card number", "number", "cn"])
            foil      = find(["foil", "finish", "printing", "is foil"])
            board     = find(["board", "section", "category"])
        }
    }

    // MARK: Value helpers

    private static func normalise(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespaces).lowercased()
    }

    private static func isFoilValue(_ raw: String) -> Bool {
        let v = raw.lowercased()
        return v == "foil" || v == "true" || v == "yes" || v == "1" || v == "etched" || v.contains("foil")
    }

    private static func boardValue(_ raw: String) -> DeckBoard {
        switch raw.lowercased() {
        case "sideboard", "side", "sb": return .sideboard
        case "maybeboard", "maybe":     return .maybeboard
        case "commander", "command":    return .commander
        default:                        return .mainboard
        }
    }

    // MARK: CSV line splitting

    /// Split one CSV line, honouring double-quoted fields (which may contain commas / escaped "").
    private static func splitCSVLine(_ line: String) -> [String] {
        var fields: [String] = []
        var current = ""
        var inQuotes = false
        var chars = Array(line)
        var i = 0
        while i < chars.count {
            let c = chars[i]
            if c == "\"" {
                if inQuotes && i + 1 < chars.count && chars[i + 1] == "\"" {
                    current.append("\"")   // escaped quote
                    i += 1
                } else {
                    inQuotes.toggle()
                }
            } else if c == "," && !inQuotes {
                fields.append(current)
                current = ""
            } else {
                current.append(c)
            }
            i += 1
        }
        fields.append(current)
        return fields
    }
}
