//
//  DeckImportParser.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Pure text parser for deck lists (Moxfield / Archidekt / TappedOut / MTGGoldfish / MTGO
//      plain text, plus MTG Arena's "(SET) collector" form). No SwiftUI / SwiftData / network
//      so it can be unit-tested in isolation. Produces ParsedDeckLine values grouped by board.
//  External Types:
//      (none)

// MARK: Imports

import Foundation

// MARK: Types

/// Which board a parsed line belongs to.
enum DeckBoard: String {
    case mainboard
    case sideboard
    case maybeboard
    case commander
}

/// One parsed deck-list line.
struct ParsedDeckLine: Equatable, Identifiable {
    let id = UUID()
    var quantity: Int
    var name: String
    /// Arena-style printing hints (optional)
    var setCode: String?
    var collectorNumber: String?
    var board: DeckBoard

    static func == (lhs: ParsedDeckLine, rhs: ParsedDeckLine) -> Bool {
        lhs.quantity == rhs.quantity &&
        lhs.name == rhs.name &&
        lhs.setCode == rhs.setCode &&
        lhs.collectorNumber == rhs.collectorNumber &&
        lhs.board == rhs.board
    }
}

// MARK: Parser

struct DeckImportParser {

    /// Parse raw deck-list text into lines. Blank lines and `//` comments are ignored;
    /// section headers switch the active board for subsequent lines.
    func parse(_ text: String) -> [ParsedDeckLine] {
        var lines: [ParsedDeckLine] = []
        var board: DeckBoard = .mainboard

        for rawLine in text.components(separatedBy: .newlines) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)

            // skip blanks + comments
            if line.isEmpty || line.hasPrefix("//") { continue }

            // section header?
            if let newBoard = boardHeader(line) {
                board = newBoard
                continue
            }

            if let parsed = parseLine(line, board: board) {
                lines.append(parsed)
            }
        }

        return lines
    }

    // MARK: Header detection

    /// Returns a board if the line is a section header (case-insensitive), else nil.
    private func boardHeader(_ line: String) -> DeckBoard? {
        // strip a trailing colon and any "(n)" count suffix some sites add
        var header = line.lowercased()
        if let paren = header.firstIndex(of: "(") {
            header = String(header[..<paren])
        }
        header = header.replacingOccurrences(of: ":", with: "").trimmingCharacters(in: .whitespaces)

        switch header {
        case "deck", "main", "mainboard":
            return .mainboard
        case "sideboard", "sb":
            return .sideboard
        case "maybeboard", "maybe":
            return .maybeboard
        case "commander", "commanders":
            return .commander
        default:
            return nil
        }
    }

    // MARK: Line parsing

    /// Parse a single card line: "4 Lightning Bolt", "4x Bolt", "1 Atraxa (M21) 162", "SB: 2 Bolt".
    private func parseLine(_ line: String, board: DeckBoard) -> ParsedDeckLine? {
        var working = line

        // optional board prefix used by some exports, e.g. "SB: 2 Card"
        var lineBoard = board
        if working.lowercased().hasPrefix("sb:") {
            lineBoard = .sideboard
            working = String(working.dropFirst(3)).trimmingCharacters(in: .whitespaces)
        }

        // leading quantity (supports "4", "4x", "4 x")
        var quantity = 1
        var tokens = working.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
        if let first = tokens.first {
            // a bare "x"/"X" multiplier token after the number is dropped too
            let qtyToken = first.lowercased().hasSuffix("x") ? String(first.dropLast()) : first
            if !qtyToken.isEmpty, qtyToken.allSatisfy({ $0.isNumber }), let qty = Int(qtyToken) {
                quantity = max(qty, 1)
                tokens.removeFirst()
                // handle a separate "x" multiplier token, e.g. "4 x Bolt"
                if tokens.first?.lowercased() == "x" {
                    tokens.removeFirst()
                }
            }
        }
        working = tokens.joined(separator: " ").trimmingCharacters(in: .whitespaces)

        guard !working.isEmpty else { return nil }

        // Arena printing hint: trailing " (SET) 123" or " (SET)"
        let (name, setCode, collector) = stripPrinting(from: working)
        guard !name.isEmpty else { return nil }

        return ParsedDeckLine(
            quantity: quantity,
            name: name,
            setCode: setCode,
            collectorNumber: collector,
            board: lineBoard
        )
    }

    /// Splits a trailing "(SET) collector" printing hint off a card name.
    private func stripPrinting(from text: String) -> (name: String, set: String?, collector: String?) {
        guard let open = text.lastIndex(of: "("),
              let close = text[open...].firstIndex(of: ")") else {
            return (text.trimmingCharacters(in: .whitespaces), nil, nil)
        }

        let set = String(text[text.index(after: open)..<close]).trimmingCharacters(in: .whitespaces)
        // a set code is short + alphanumeric; guard against stripping real parentheses in a name
        guard (1...6).contains(set.count), set.allSatisfy({ $0.isLetter || $0.isNumber }) else {
            return (text.trimmingCharacters(in: .whitespaces), nil, nil)
        }

        let name = String(text[..<open]).trimmingCharacters(in: .whitespaces)
        let after = String(text[text.index(after: close)...]).trimmingCharacters(in: .whitespaces)
        let collector = after.isEmpty ? nil : after

        return (name, set.uppercased(), collector)
    }
}
