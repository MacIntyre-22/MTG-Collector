//
//  DeckSuggestionsSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Presents rule-based deck suggestions: per-weakness sections with a plain-English reason
//      and a horizontal row of EDHREC-ranked Scryfall cards (tap to view / add). The archetype
//      can be overridden to retune the thresholds.
//
//      NOTE: This is a Pro feature — gate behind ProAccessManager in Phase 6.
//  External Types:
//      Deck, DeckSuggestionViewModel, DeckArchetype, SFAPI, SearchCardView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct DeckSuggestionsSheet: View {

    // MARK: Stored Properties

    var deck: Deck

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = DeckSuggestionViewModel()

    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    archetypePicker

                    if viewModel.isLoading {
                        ProgressView("Analysing deck…")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                    } else if viewModel.sections.isEmpty {
                        emptyState
                    } else {
                        ForEach(viewModel.sections) { section in
                            sectionView(section)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Suggestions")
            .task { await viewModel.analyze(deck: deck, context: modelContext) }
        }
    }

    // MARK: Subviews

    private var archetypePicker: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Archetype")
                .font(.headline)
            Picker("Archetype", selection: $viewModel.archetype) {
                Text("Auto").tag(DeckArchetype?.none)
                ForEach(DeckArchetype.allCases) { arch in
                    Text(arch.label).tag(DeckArchetype?.some(arch))
                }
            }
            .pickerStyle(.menu)
            .onChange(of: viewModel.archetype) { _, _ in
                Task { await viewModel.analyze(deck: deck, context: modelContext) }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .resizable().scaledToFit().frame(width: 60, height: 60)
                .foregroundStyle(.green)
            Text("No weaknesses detected")
                .font(.title3.bold())
            Text("This deck looks balanced for its archetype and format.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    private func sectionView(_ section: DeckSuggestionViewModel.SuggestionSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.reason)
                .font(.subheadline)
                .foregroundStyle(.primary)

            if !section.cards.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(section.cards) { card in
                            SearchCardView(card: SFAPI.JSONtoModel(json: card))
                                .frame(width: 160)
                        }
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
