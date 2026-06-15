//
//  DeckSuggestionViewModel.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Orchestrates the deck suggestion flow: resolve the deck's cards, compute features +
//      weaknesses (DeckSuggestionEngine), then fire one Scryfall query per weakness
//      (SuggestionQueryBuilder) ordered by EDHREC rank, excluding cards already in the deck.
//      Drives the suggestion UI.
//  External Types:
//      Deck, DeckSuggestionEngine, SuggestionQueryBuilder, CardStore, SFAPI, CardJSON

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@MainActor
final class DeckSuggestionViewModel: ObservableObject {

    struct SuggestionSection: Identifiable {
        let id = UUID()
        var flag: WeaknessFlag
        var reason: String
        var cards: [CardJSON]   // empty for structural advice (e.g. too many lands)
    }

    // MARK: Published State

    @Published var sections: [SuggestionSection] = []
    @Published var features: DeckStatsFeatures?
    @Published var isLoading = false
    /// optional user override; nil = auto-infer
    @Published var archetype: DeckArchetype?

    // MARK: Dependencies

    private let engine = DeckSuggestionEngine()
    private let builder = SuggestionQueryBuilder()

    // MARK: Analyze

    func analyze(deck: Deck, context: ModelContext) async {
        isLoading = true
        defer { isLoading = false }

        let lookup = CardStore.lookup(for: deck.mainboard.map { $0.scryfallCardID }, context: context)
        let f = engine.features(for: deck, lookup: lookup, archetype: archetype)
        features = f

        let flags = engine.weaknesses(for: f)
        let t = engine.thresholds(format: f.format, archetype: f.archetype)
        let owned = Set(deck.mainboard.map { $0.scryfallCardID })

        var built: [SuggestionSection] = []
        for flag in flags {
            let reason = builder.reason(for: flag, features: f, thresholds: t)
            if let query = builder.query(for: flag, features: f) {
                let results = await SFAPI.fetchCards(query: query, order: "edhrec", descending: false)
                let filtered = results.filter { card in
                    guard let id = card.id else { return true }
                    return !owned.contains(id)
                }
                built.append(SuggestionSection(flag: flag, reason: reason, cards: Array(filtered.prefix(10))))
            } else {
                built.append(SuggestionSection(flag: flag, reason: reason, cards: []))
            }
        }
        sections = built
    }
}
