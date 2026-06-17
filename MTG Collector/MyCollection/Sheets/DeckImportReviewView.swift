//
//  DeckImportReviewView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      The review step of the deck-import flow (Phase 5). After the resolver runs, this shows the
//      matched cards grouped by board and any names Scryfall couldn't resolve, letting the user
//      manually search-and-match each unresolved line before committing. Pure UI over the
//      DeckImportViewModel — committing to a Deck is the caller's job.
//  External Types:
//      DeckImportViewModel, ResolvedDeckCard, ParsedDeckLine, DeckBoard, CardJSON, SFAPI
//

// MARK: Imports

import SwiftUI

// MARK: Review

struct DeckImportReviewView: View {

    // MARK: Stored Properties

    @ObservedObject var importVM: DeckImportViewModel
    /// Called when the user confirms the import; receives nothing — caller reads importVM.result.
    var onConfirm: () -> Void

    // MARK: State Properties

    @Environment(\.dismiss) private var dismiss
    @State private var matchLine: ParsedDeckLine?
    @State private var isCommitting = false

    private let boardOrder: [DeckBoard] = [.commander, .mainboard, .sideboard, .maybeboard]

    // MARK: View

    var body: some View {
        NavigationStack {
            List {
                if importVM.isResolving {
                    HStack {
                        ProgressView()
                        Text("Resolving cards…").foregroundStyle(.secondary)
                    }
                } else {
                    unresolvedSection
                    matchedSections
                }
            }
            .navigationTitle("Review Import")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isCommitting {
                        ProgressView()
                    } else {
                        Button("Add \(importVM.resolvedCount)") {
                            isCommitting = true
                            onConfirm()
                        }
                        .disabled(importVM.resolvedCount == 0)
                    }
                }
            }
            .sheet(item: $matchLine) { line in
                UnresolvedMatchSheet(line: line) { card in
                    importVM.attachMatch(card, to: line)
                }
            }
        }
    }

    // MARK: Sections

    @ViewBuilder
    private var matchedSections: some View {
        ForEach(boardOrder, id: \.self) { board in
            let cards = importVM.resolvedByBoard[board] ?? []
            if !cards.isEmpty {
                Section("\(board.rawValue.capitalized) (\(cards.reduce(0) { $0 + $1.line.quantity }))") {
                    ForEach(cards) { resolved in
                        HStack {
                            Text("\(resolved.line.quantity)×")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                            Text(resolved.card.name)
                            Spacer()
                            if let set = resolved.card.set {
                                Text(set.uppercased())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var unresolvedSection: some View {
        if !importVM.result.unresolved.isEmpty {
            Section {
                ForEach(importVM.result.unresolved) { line in
                    Button {
                        matchLine = line
                    } label: {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            VStack(alignment: .leading) {
                                Text(line.name).foregroundStyle(.primary)
                                Text("Tap to find a match")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
            } header: {
                Text("Couldn't find (\(importVM.unresolvedCount))")
            } footer: {
                Text("These names didn't match a card. Tap one to search Scryfall and pick the right card, or leave it out.")
            }
        }
    }
}

// MARK: Manual Match Sheet

/// Lets the user search Scryfall and pick a card to resolve an unmatched deck-list line.
struct UnresolvedMatchSheet: View {

    let line: ParsedDeckLine
    var onPick: (CardJSON) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""
    @State private var results: [CardJSON] = []
    @State private var searching = false

    var body: some View {
        NavigationStack {
            List {
                if searching {
                    HStack { ProgressView(); Text("Searching…").foregroundStyle(.secondary) }
                } else if results.isEmpty {
                    Text("No matches. Try a different spelling.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(results) { card in
                        Button {
                            onPick(card)
                            dismiss()
                        } label: {
                            HStack {
                                Text(card.name).foregroundStyle(.primary)
                                Spacer()
                                if let set = card.set {
                                    Text(set.uppercased())
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $query, prompt: "Card name")
            .onSubmit(of: .search) { Task { await search() } }
            .navigationTitle("Find “\(line.name)”")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .task {
                query = line.name
                await search()
            }
        }
    }

    private func search() async {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { results = []; return }
        searching = true
        results = await SFAPI.fetchCards(query: trimmed, order: "name")
        searching = false
    }
}
