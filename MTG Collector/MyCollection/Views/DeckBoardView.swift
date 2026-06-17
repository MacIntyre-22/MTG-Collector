//
//  DeckBoardView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      One board of a deck (main / side / maybe) — replaces the three near-identical board views.
//      Shows a header with the card count, a summary of any illegal cards (same warning icon and
//      colours as the cards), and a legality filter; then the card grid or an empty state.
//  External Types:
//      Deck, CardEntry, Card, CardStore, LegalityStatus, LegalityFilter, DeckCardView, StatsUpdater
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Board kind

enum DeckBoardKind: Hashable {
    case main, side, maybe

    var title: String {
        switch self {
        case .main: return "Mainboard"
        case .side: return "Sideboard"
        case .maybe: return "Maybeboard"
        }
    }

    func entries(of deck: Deck) -> [CardEntry] {
        switch self {
        case .main: return deck.mainboard
        case .side: return deck.sideboard
        case .maybe: return deck.maybeboard
        }
    }

    func remove(_ entry: CardEntry, from deck: Deck) {
        switch self {
        case .main: deck.mainboard.removeAll { $0.id == entry.id }
        case .side: deck.sideboard.removeAll { $0.id == entry.id }
        case .maybe: deck.maybeboard.removeAll { $0.id == entry.id }
        }
    }
}

// MARK: View

struct DeckBoardView: View {

    // MARK: Stored Properties

    var deck: Deck
    var board: DeckBoardKind
    /// Shared collection filter applied to every board (from DeckView).
    var filters: FilterState = FilterState()
    var isFiltering: Bool = false
    var filterToken: Int = 0
    let cardColumns = [GridItem(.adaptive(minimum: 170, maximum: 170), spacing: 15)]

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var lookup: [String: Card] = [:]
    @State private var legalFilter: LegalityFilter = .all
    /// This board's cards after the shared collection filter (engine output).
    @State private var stateFiltered: [CardEntry] = []

    // MARK: Derived Data

    private var activeEntries: [CardEntry] {
        board.entries(of: deck)
            .filter { !$0.isDeleted }
            .sorted { $0.dateAdded > $1.dateAdded }
    }

    /// Base list: the collection-filtered entries when filtering, else all active entries.
    private var baseEntries: [CardEntry] {
        isFiltering ? stateFiltered.filter { !$0.isDeleted } : activeEntries
    }

    private func status(_ entry: CardEntry) -> LegalityStatus {
        guard let card = lookup[entry.scryfallCardID] else { return .unknown }
        return LegalityStatus.of(card, ruleType: deck.ruleType)
    }

    private var filteredEntries: [CardEntry] {
        baseEntries.filter { legalFilter.matches(status($0)) }
    }

    private var totalCount: Int {
        activeEntries.reduce(0) { $0 + $1.quantity }
    }

    /// Illegal-card counts grouped by status (not legal, banned, restricted), in a stable order.
    private var issueCounts: [(status: LegalityStatus, count: Int)] {
        var counts: [LegalityStatus: Int] = [:]
        for entry in activeEntries {
            let s = status(entry)
            if s.isProblem { counts[s, default: 0] += entry.quantity }
        }
        let order: [LegalityStatus] = [.notLegal, .banned, .restricted]
        return order.compactMap { s in counts[s].map { (s, $0) } }
    }

    // MARK: View

    var body: some View {
        VStack(spacing: 10) {
            header

            if activeEntries.isEmpty {
                emptyState("No cards in the \(board.title.lowercased()) yet.")
            } else if filteredEntries.isEmpty {
                emptyState("No cards match this filter.")
            } else {
                LazyVGrid(columns: cardColumns) {
                    ForEach(filteredEntries) { entry in
                        DeckCardView(deck: deck, entry: entry, deleteEntry: {
                            board.remove(entry, from: deck)
                            StatsUpdater.update(deck, context: modelContext)
                        })
                    }
                }
            }
        }
        .task(id: "\(filterToken)-\(isFiltering)-" + activeEntries.map { $0.scryfallCardID }.joined()) {
            await resolveLookup()
            if isFiltering {
                stateFiltered = await CollectionFilterEngine(entries: activeEntries, context: modelContext)
                    .apply(filters: filters)
            } else {
                stateFiltered = []
            }
        }
    }

    // MARK: Subviews

    private var header: some View {
        HStack(spacing: 8) {
            Text(board.title)
                .font(.title3)
                .bold()
            Image(systemName: "square.stack")
                .foregroundStyle(.secondary)
            Text("\(totalCount)")
                .foregroundStyle(.secondary)

            Spacer()

            // illegal-card summary — same icon + colours as the cards
            ForEach(issueCounts, id: \.status) { item in
                HStack(spacing: 2) {
                    Image(systemName: item.status.icon)
                        .foregroundColor(item.status.color)
                    Text("\(item.count)")
                }
                .font(.subheadline)
            }

            Menu {
                Picker("Legality", selection: $legalFilter) {
                    ForEach(LegalityFilter.allCases) { Text($0.rawValue).tag($0) }
                }
            } label: {
                Image(systemName: legalFilter == .all
                      ? "line.3.horizontal.decrease.circle"
                      : "line.3.horizontal.decrease.circle.fill")
            }
        }
        .padding(.horizontal)
    }

    private func emptyState(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
    }

    // MARK: Resolve

    /// Resolve all board cards (cache first, then network) so the counts/filter are accurate.
    private func resolveLookup() async {
        var result = lookup
        for entry in activeEntries where result[entry.scryfallCardID] == nil {
            if let cached = CardStore.cached(entry.scryfallCardID, context: modelContext) {
                result[entry.scryfallCardID] = cached
            } else if let fetched = await CardStore.resolve(entry.scryfallCardID, context: modelContext) {
                result[entry.scryfallCardID] = fetched
            }
        }
        lookup = result
    }
}
