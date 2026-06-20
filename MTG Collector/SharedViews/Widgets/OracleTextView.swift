//
//  OracleTextView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Card text rendering pipeline:
//        • OracleParser   — tokenises oracle text into plain text, {symbol} tokens and loyalty costs
//        • OracleTextView — renders tokens as a VStack: inline Text+Image for normal lines,
//                           LoyaltyCostBadge + text for planeswalker ability lines
//        • ManaCostView   — horizontal strip of OracleSymbolImage for a mana cost string
//        • SymbolRowView  — row of OracleSymbolImage for colour-identity / produced-mana arrays
//        • OracleSymbolImage — standalone cached symbol image (async load from SymbolCache)
//        • LoyaltyCostBadge  — coloured capsule for +1 / −2 / 0 loyalty costs
//  External Types:
//      SymbolStore, SymbolCache
//

// MARK: Imports

import SwiftUI

// MARK: - Token

private enum OracleToken: Equatable {
    case text(String, italic: Bool)
    case symbol(String)         // e.g. "{W}", "{T}", "{2/U}"
    case loyaltyCost(String)    // e.g. "+1", "−2", "0"
}

// MARK: - Parser

private enum OracleParser {

    /// Split text by newlines, each line returns its own token array.
    static func parse(_ text: String) -> [[OracleToken]] {
        text.components(separatedBy: "\n").map { parseLine($0) }
    }

    /// Unique symbol keys found anywhere in `text` (for pre-loading).
    static func symbolKeys(in text: String) -> [String] {
        var keys: [String] = []
        var i = text.startIndex
        while i < text.endIndex {
            if text[i] == "{", let end = text[i...].firstIndex(of: "}") {
                let key = String(text[i...end])
                if !keys.contains(key) { keys.append(key) }
                i = text.index(after: end)
            } else {
                i = text.index(after: i)
            }
        }
        return keys
    }

    /// All symbol occurrences in order (may contain duplicates) — used for ManaCostView.
    static func allSymbols(in text: String) -> [String] {
        var result: [String] = []
        var i = text.startIndex
        while i < text.endIndex {
            if text[i] == "{", let end = text[i...].firstIndex(of: "}") {
                result.append(String(text[i...end]))
                i = text.index(after: end)
            } else {
                i = text.index(after: i)
            }
        }
        return result
    }

    // MARK: Private

    private static func parseLine(_ line: String) -> [OracleToken] {
        var tokens: [OracleToken] = []
        var remaining = line

        if let (cost, rest) = extractLoyaltyCost(from: line) {
            tokens.append(.loyaltyCost(cost))
            remaining = rest
        }
        tokens.append(contentsOf: parseInline(remaining))
        return tokens
    }

    /// Detects planeswalker loyalty costs at the start of a line: +1:, −3:, 0:, +X:
    private static func extractLoyaltyCost(from line: String) -> (cost: String, remainder: String)? {
        guard let colonIdx = line.firstIndex(of: ":") else { return nil }
        let candidate = String(line[line.startIndex..<colonIdx])
        // Strip leading sign to check the numeric/X part
        var stripped = candidate
        if stripped.hasPrefix("+") || stripped.hasPrefix("-") || stripped.hasPrefix("−") {
            stripped = String(stripped.dropFirst())
        }
        guard !stripped.isEmpty,
              Int(stripped) != nil || stripped.uppercased() == "X" else { return nil }
        // Must start with a recognised sign or be "0"
        let first = candidate.unicodeScalars.first.map { Character($0) }
        guard first == "+" || first == "-" || candidate.hasPrefix("−") || candidate == "0" else { return nil }
        return (candidate, String(line[colonIdx...]))
    }

    private static func parseInline(_ text: String) -> [OracleToken] {
        var tokens: [OracleToken] = []
        var italic = false
        var current = ""
        var i = text.startIndex

        func flush() {
            guard !current.isEmpty else { return }
            tokens.append(.text(current, italic: italic))
            current = ""
        }

        while i < text.endIndex {
            let c = text[i]
            if c == "{" {
                flush()
                if let end = text[i...].firstIndex(of: "}") {
                    tokens.append(.symbol(String(text[i...end])))
                    i = text.index(after: end)
                    continue
                }
            } else if c == "(" {
                flush(); italic = true; current.append(c)
            } else if c == ")" {
                current.append(c); flush(); italic = false
            } else {
                current.append(c)
            }
            i = text.index(after: i)
        }
        flush()
        return tokens
    }
}

// MARK: - Loyalty Cost Badge

struct LoyaltyCostBadge: View {
    let cost: String

    /// Matches the legality palette: gain (+) green, cost (−) red, neutral (0) grey.
    private var color: Color {
        let trimmed = cost.trimmingCharacters(in: .whitespaces)
        if trimmed.hasPrefix("+") { return .statusGreen }
        if trimmed.hasPrefix("-") || trimmed.hasPrefix("−") { return .statusRed }
        return Color(.systemGray)
    }

    /// Normalise Unicode minus sign to hyphen-minus so it renders cleanly in all fonts.
    private var display: String { cost.replacingOccurrences(of: "−", with: "-") }

    var body: some View {
        Text(display)
            .font(.caption.weight(.bold))
            .foregroundColor(.white)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(color)
            .clipShape(Capsule())
    }
}

// MARK: - Standalone Symbol Image

/// A single cached mana/game symbol rendered at the given point size.
/// Shows a small placeholder circle while loading.
struct OracleSymbolImage: View {
    let symbol: String
    var size: CGFloat = 22

    @State private var img: UIImage?

    var body: some View {
        Group {
            if let img {
                Image(uiImage: img)
                    .resizable()
                    .interpolation(.high)
                    .scaledToFit()
            } else {
                Circle()
                    .fill(Color(.systemGray5))
            }
        }
        .frame(width: size, height: size)
        .padding(.horizontal, 1)
        .task(id: symbol) {
            if let cached = SymbolCache.shared.image(for: symbol) { img = cached; return }
            guard let uri = SymbolStore.uri(for: symbol) else { return }
            img = await SymbolCache.shared.load(symbol: symbol, uri: uri)
        }
    }
}

// MARK: - Mana Cost Row

/// Horizontal strip of symbol images from a mana cost string like "{3}{W}{W}".
struct ManaCostView: View {
    let cost: String
    var symbolSize: CGFloat = 22

    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(OracleParser.allSymbols(in: cost).enumerated()), id: \.offset) { _, sym in
                OracleSymbolImage(symbol: sym, size: symbolSize)
            }
        }
    }
}

// MARK: - Symbol Row (colour identity / produced mana)

/// Row of symbol images from colour-letter arrays like ["W", "U"]. Maps "W" → "{W}" etc.
struct SymbolRowView: View {
    let colorLetters: [String]
    var symbolSize: CGFloat = 22

    var body: some View {
        HStack(spacing: 4) {
            ForEach(colorLetters, id: \.self) { letter in
                OracleSymbolImage(symbol: "{\(letter)}", size: symbolSize)
            }
        }
    }
}

// MARK: - Oracle Text View

/// Full oracle text renderer: inline symbols, italic reminder text, loyalty cost badges.
struct OracleTextView: View {
    let text: String
    var fontSize: CGFloat = 14

    /// Scaled symbol images keyed by symbol string — pre-loaded before rendering.
    @State private var symbolImages: [String: UIImage] = [:]

    private var lines: [[OracleToken]] { OracleParser.parse(text) }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(Array(lines.enumerated()), id: \.offset) { _, tokens in
                lineView(tokens)
            }
        }
        .task(id: text) { await loadSymbols() }
    }

    // MARK: Line rendering

    @ViewBuilder
    private func lineView(_ tokens: [OracleToken]) -> some View {
        if case .loyaltyCost(let cost) = tokens.first {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                LoyaltyCostBadge(cost: cost)
                assembleText(Array(tokens.dropFirst()))
                    .font(.system(size: fontSize))
                    .fixedSize(horizontal: false, vertical: true)
            }
        } else {
            assembleText(tokens)
                .font(.system(size: fontSize))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func assembleText(_ tokens: [OracleToken]) -> Text {
        tokens.reduce(Text("")) { acc, token in
            switch token {
            case .text(let s, italic: true):
                return acc + Text(s).italic().foregroundStyle(Color.secondary)
            case .text(let s, italic: false):
                return acc + Text(s)
            case .symbol(let key):
                if let img = symbolImages[key] {
                    return acc + Text(Image(uiImage: img))
                }
                // Placeholder text until the image is ready
                let inner = key.dropFirst().dropLast()
                return acc + Text("{\(inner)}")
                    .font(.system(size: fontSize - 2))
                    .foregroundStyle(Color.secondary)
            case .loyaltyCost(let c):
                return acc + Text(c).bold()
            }
        }
    }

    // MARK: Symbol loading

    private func loadSymbols() async {
        let targetSize = fontSize + 4
        for key in OracleParser.symbolKeys(in: text) where symbolImages[key] == nil {
            var raw: UIImage?
            if let cached = SymbolCache.shared.image(for: key) {
                raw = cached
            } else if let uri = SymbolStore.uri(for: key) {
                raw = await SymbolCache.shared.load(symbol: key, uri: uri)
            }
            // Bake a small left/right margin into each inline symbol so it doesn't touch the
            // surrounding words (the cost-row symbols use SwiftUI padding; inline text can't).
            if let raw { symbolImages[key] = raw.scaledToPoint(targetSize, horizontalPadding: 2.5) }
        }
    }
}
