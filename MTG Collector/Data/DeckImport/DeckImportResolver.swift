//
//  DeckImportResolver.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Resolves parsed deck lines into real Scryfall cards using the /cards/collection bulk
//      endpoint (75 identifiers per request, batches fired in parallel). Pure async logic —
//      no SwiftUI / SwiftData — returning matched cards plus any names Scryfall couldn't find,
//      so the import UI can show a review screen.
//  External Types:
//      ParsedDeckLine, SFAPI, CardJSON, CardIdentifierJSON

// MARK: Imports

import Foundation

// MARK: Result Types

/// A parsed line successfully matched to a Scryfall card.
struct ResolvedDeckCard: Identifiable {
    let id = UUID()
    var line: ParsedDeckLine
    var card: CardJSON
}

/// The outcome of resolving a whole deck list.
struct DeckImportResult {
    var resolved: [ResolvedDeckCard] = []
    var unresolved: [ParsedDeckLine] = []
}

// MARK: Resolver

struct DeckImportResolver {

    private let batchSize = 75

    /// Resolve parsed lines into cards. Batches of 75 identifiers are fired concurrently.
    func resolve(_ lines: [ParsedDeckLine]) async -> DeckImportResult {
        guard !lines.isEmpty else { return DeckImportResult() }

        // Fire each batch concurrently, collecting (foundCards, notFoundIdentifiers).
        let batches = chunk(lines, into: batchSize)

        var foundCards: [CardJSON] = []
        await withTaskGroup(of: [CardJSON].self) { group in
            for batch in batches {
                let identifiers = batch.map(identifier(for:))
                group.addTask {
                    await SFAPI.fetchCardCollection(identifiers: identifiers).found
                }
            }
            for await found in group {
                foundCards.append(contentsOf: found)
            }
        }

        return match(lines: lines, to: foundCards)
    }

    // MARK: Identifier mapping

    /// Prefer an exact printing (set + collector number) when present, else match by name.
    private func identifier(for line: ParsedDeckLine) -> CardIdentifierJSON {
        if let set = line.setCode, let cn = line.collectorNumber {
            return CardIdentifierJSON(name: nil, set: set.lowercased(), collectorNumber: cn)
        }
        return CardIdentifierJSON(name: line.name, set: nil, collectorNumber: nil)
    }

    // MARK: Matching back to lines

    private func match(lines: [ParsedDeckLine], to cards: [CardJSON]) -> DeckImportResult {
        // Index found cards by lowercased name and by set+collector for quick lookup.
        var byName: [String: CardJSON] = [:]
        var byPrinting: [String: CardJSON] = [:]
        for card in cards {
            byName[card.name.lowercased()] = card
            if let set = card.set, let cn = card.collectorNumber {
                byPrinting["\(set.lowercased())|\(cn)"] = card
            }
        }

        var result = DeckImportResult()
        for line in lines {
            if let set = line.setCode, let cn = line.collectorNumber,
               let card = byPrinting["\(set.lowercased())|\(cn)"] {
                result.resolved.append(ResolvedDeckCard(line: line, card: card))
            } else if let card = byName[line.name.lowercased()] {
                result.resolved.append(ResolvedDeckCard(line: line, card: card))
            } else {
                result.unresolved.append(line)
            }
        }
        return result
    }

    // MARK: Helpers

    private func chunk<T>(_ array: [T], into size: Int) -> [[T]] {
        guard size > 0 else { return [array] }
        return stride(from: 0, to: array.count, by: size).map {
            Array(array[$0 ..< min($0 + size, array.count)])
        }
    }
}
