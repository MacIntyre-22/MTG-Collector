//
//  DeckImportViewModel.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Drives the deck-import flow: owns the parser + resolver, exposes observable state for
//      the import UI (raw text in, parsed/resolved out, loading + unresolved review). Stays
//      decoupled from SwiftData — turning the result into an actual Deck (caching cards via
//      CardStore, creating CardEntry per board) is done by the import UI on commit.
//
//      TODO(device): build the import UI (paste field + .fileImporter for .txt), the review
//      screen (matched grouped by board + unresolved list), and commitToDeck(context:) which
//      caches each resolved CardJSON via CardStore and creates the Deck + CardEntry records.
//  External Types:
//      DeckImportParser, DeckImportResolver, ParsedDeckLine, DeckImportResult, ResolvedDeckCard

// MARK: Imports

import Foundation

// MARK: Types

@MainActor
final class DeckImportViewModel: ObservableObject {

    // MARK: Published State

    @Published var rawText: String = ""
    @Published var parsedLines: [ParsedDeckLine] = []
    @Published var result: DeckImportResult = DeckImportResult()
    @Published var isResolving: Bool = false
    @Published var hasResolved: Bool = false

    // MARK: Dependencies

    private let resolver = DeckImportResolver()

    // MARK: Derived

    /// Resolved cards grouped by board, for the review screen.
    var resolvedByBoard: [DeckBoard: [ResolvedDeckCard]] {
        Dictionary(grouping: result.resolved, by: { $0.line.board })
    }

    var unresolvedCount: Int { result.unresolved.count }
    var resolvedCount: Int { result.resolved.count }

    // MARK: Actions

    /// Optional source filename (set when importing a file) so CSV vs text is detected reliably.
    var sourceFilename: String?

    /// Parse the current raw text, auto-detecting plain-text vs CSV (no network).
    func parse() {
        parsedLines = CollectionImporter.parse(rawText, filename: sourceFilename)
        hasResolved = false
        result = DeckImportResult()
    }

    /// Parse (if needed) then resolve against Scryfall.
    func resolve() async {
        if parsedLines.isEmpty {
            parse()
        }
        guard !parsedLines.isEmpty else { return }

        isResolving = true
        result = await resolver.resolve(parsedLines)
        isResolving = false
        hasResolved = true
    }

    /// Manually mark an unresolved line as resolved once the user picks a match in the UI.
    func attachMatch(_ card: CardJSON, to line: ParsedDeckLine) {
        result.unresolved.removeAll { $0.id == line.id }
        result.resolved.append(ResolvedDeckCard(line: line, card: card))
    }

    func reset() {
        rawText = ""
        parsedLines = []
        result = DeckImportResult()
        isResolving = false
        hasResolved = false
    }
}
