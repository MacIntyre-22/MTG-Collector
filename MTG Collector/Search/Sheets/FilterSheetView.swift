//
//  FilterSheetView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      The single reusable filter UI. Binds to a shared FilterState and shows/hides options
//      based on the injected context (Scryfall search vs a local collection). The calling
//      view owns the engine and runs it in `onApply`; this view knows nothing about engines.
//
//      NOTE: This is the Phase 3 unified replacement for the legacy `FilterSheet`. Search/
//      Binder/Deck views are switched over to it in Phase 4 (screen reworks).
//  External Types:
//      FilterState, FilterSort, SetInfo, SetsFilterWidget

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

/// Which fields are relevant for the current caller.
enum FilterContext {
    case scryfall
    case collection
    case deck        // a deck board — same as collection, plus the legality filter
}

struct FilterSheetView: View {

    // MARK: Stored Properties

    var context: FilterContext
    var onApply: () -> Void

    let allColors = ["W", "U", "B", "R", "G"]
    let allTypes = ["Creature", "Instant", "Sorcery", "Artifact", "Enchantment", "Land", "Planeswalker"]
    let allRarities = ["common", "uncommon", "rare", "mythic", "special"]
    let formats = ["standard", "modern", "legacy", "vintage", "commander", "pauper", "pioneer"]
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 15),
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 15)
    ]

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @Environment(\.appTint) private var tint
    @Query var sets: [SetInfo]
    @Binding var filters: FilterState

    private var isScryfall: Bool { context == .scryfall }
    private var isDeck: Bool { context == .deck }

    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                resetSection
                // Legality sits up top for decks so it's the first, quickest filter to reach.
                if isDeck { legalitySection }
                sortSection
                colorsSection
                typesSection
                raritiesSection
                cmcSection
                if isScryfall {
                    scryfallSection
                    producedManaSection
                } else {
                    collectionSection
                }
                setsSection
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Apply") {
                        onApply()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
        .tint(tint)
    }

    // MARK: Sections

    private var resetSection: some View {
        Section {
            HStack {
                Spacer()
                Button("Reset") { filters.reset() }.bold()
                Spacer()
            }
        }
    }

    private var legalitySection: some View {
        Section("Legality") {
            Picker("Show", selection: $filters.legality) {
                ForEach(LegalityFilter.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
        }
    }

    private var sortSection: some View {
        Section("Sort") {
            Picker("Sort By", selection: $filters.sortBy) {
                ForEach(FilterSort.allCases) { sort in
                    // hide collection-only sort for Scryfall and vice-versa
                    if sort != .dateAdded || !isScryfall {
                        Text(sort.label).tag(sort)
                    }
                }
            }
            Toggle("Descending", isOn: $filters.sortDescending)
        }
    }

    private var colorsSection: some View {
        Section("Colours") {
            HStack {
                ForEach(allColors, id: \.self) { color in
                    Button {
                        toggle(array: &filters.colors, value: color)
                    } label: {
                        OracleSymbolImage(symbol: "{\(color)}", size: 44)
                            .padding(5)
                            .background(filters.colors.contains(color) ? .gray.opacity(0.18) : .clear)
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)
                }
            }
            Button("Clear", role: .destructive) { filters.colors = [] }
        }
    }

    private var typesSection: some View {
        Section("Types") {
            chipGrid(all: allTypes, selected: filters.types, toggle: { toggle(array: &filters.types, value: $0) }, label: { $0 })
            Button("Clear", role: .destructive) { filters.types = [] }
        }
    }

    private var raritiesSection: some View {
        Section("Rarities") {
            chipGrid(all: allRarities, selected: filters.rarities, toggle: { toggle(array: &filters.rarities, value: $0) }, label: { $0.capitalized })
            Button("Clear", role: .destructive) { filters.rarities = [] }
        }
    }

    private var cmcSection: some View {
        Section("Mana Value") {
            HStack(spacing: 40) {
                Text("Min: \(Int(filters.cmcLower))")
                Text("Max: \(Int(filters.cmcUpper))")
            }
            Slider(value: $filters.cmcLower, in: 0...20, step: 1)
            Slider(value: $filters.cmcUpper, in: 0...20, step: 1)
            // keep min from exceeding max in the UI
            if filters.cmcLower > filters.cmcUpper {
                Text("Min can't exceed Max")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            Button("Clear", role: .destructive) {
                filters.cmcLower = 0
                filters.cmcUpper = 20
            }
        }
    }

    private var scryfallSection: some View {
        Section("Format & Commander") {
            Picker("Legal in", selection: $filters.formatLegality) {
                Text("Any").tag("")
                ForEach(formats, id: \.self) { Text($0.capitalized).tag($0) }
            }
            Toggle("Can be Commander", isOn: $filters.isCommander)
        }
    }

    private var producedManaSection: some View {
        Section("Produces Mana") {
            HStack {
                ForEach(allColors, id: \.self) { color in
                    Button {
                        toggle(array: &filters.producedMana, value: color)
                    } label: {
                        OracleSymbolImage(symbol: "{\(color)}", size: 44)
                            .padding(5)
                            .background(filters.producedMana.contains(color) ? .gray.opacity(0.18) : .clear)
                            .cornerRadius(5)
                    }
                    .buttonStyle(.plain)
                }
            }
            Button("Clear", role: .destructive) { filters.producedMana = [] }
        }
    }

    private var collectionSection: some View {
        Section("Collection") {
            Toggle("Foil only", isOn: $filters.foilOnly)
            Toggle("Favourites only", isOn: $filters.favouritesOnly)
        }
    }

    private var setsSection: some View {
        Section("Sets") {
            SetsFilterWidget(selected: filters.sets) { code in
                toggle(array: &filters.sets, value: code)
            }
            VStack(alignment: .leading) {
                Text("Added Sets").bold().padding(.bottom, 10)
                ForEach(filters.sets, id: \.self) { code in
                    if let set = sets.first(where: { $0.code == code }) {
                        Text(set.name.capitalized).foregroundColor(.gray)
                    } else {
                        Text(code.uppercased()).foregroundColor(.secondary)
                    }
                }
            }
            Button("Clear", role: .destructive) { filters.sets = [] }
        }
    }

    // MARK: Reusable chip grid

    @ViewBuilder
    private func chipGrid(all: [String], selected: [String], toggle: @escaping (String) -> Void, label: @escaping (String) -> String) -> some View {
        LazyVGrid(columns: columns, spacing: 5) {
            ForEach(all, id: \.self) { value in
                let contains = selected.contains(value)
                Button {
                    toggle(value)
                } label: {
                    Text(label(value))
                        .foregroundColor(contains ? .white : tint)
                        .lineLimit(1)
                        .frame(maxWidth: 300, maxHeight: 30)
                        .padding(5)
                        .background(contains ? tint : .clear)
                        .cornerRadius(5)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: Toggle Filter

    func toggle(array: inout [String], value: String) {
        if let index = array.firstIndex(of: value) {
            array.remove(at: index)
        } else {
            array.append(value)
        }
    }
}
