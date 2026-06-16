//
//  DeckSuggestionsView.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      The suggestion feed for a deck. Runs DeckSuggestionEngine and shows each weakness as a
//      titled group with a plain-English reason and a horizontal row of suggested cards (which
//      can be added to a collection via the standard card controls).
//
//      Pro feature — gate behind Settings.isPro once IAP lands.
//  External Types:
//      Deck, DeckSuggestionEngine, DeckSuggestionGroup, CardJSON, SFAPI, SearchCardView
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct DeckSuggestionsView: View {

    // MARK: Stored Properties

    var deck: Deck

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var groups: [DeckSuggestionGroup] = []
    @State private var isLoading = true

    private let engine = DeckSuggestionEngine()

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Analysing your deck…")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else if groups.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("No suggestions right now")
                            .font(.title3.bold())
                        Text("Your deck looks balanced, or we couldn't find cards for its colours and format.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 30)
                    }
                    .frame(maxWidth: .infinity, minHeight: 300)
                } else {
                    VStack(spacing: 15) {
                        ForEach(groups) { group in
                            suggestionGroup(group)
                        }
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("Suggestions")
            .task {
                groups = await engine.suggestions(for: deck)
                isLoading = false
            }
        }
    }

    // MARK: Subviews

    private func suggestionGroup(_ group: DeckSuggestionGroup) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(group.weakness.title)
                .font(.title3)
                .bold()
            Text(group.weakness.reason)
                .font(.caption)
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(group.cards) { json in
                        let card = SFAPI.JSONtoModel(json: json)
                        SearchCardView(card: card)
                            .frame(width: 170)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .widgetStyle()
        .padding(.horizontal, 10)
    }
}
