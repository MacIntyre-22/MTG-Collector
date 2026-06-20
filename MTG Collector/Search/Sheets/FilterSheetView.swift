//
//  FilterSheetView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      The single reusable filter UI. Binds to a shared FilterState and shows/hides options
//      based on the injected context. Search exposes the full set of Scryfall query filters;
//      collection contexts (My Hold, a Binder, a Deck) put their own controls in a titled section
//      at the top and then share the card-attribute filters. The calling view owns the engine and
//      runs it in `onApply`; this view knows nothing about engines.
//
//      Selection highlights are pill (Capsule) backgrounds to match the rest of the app, and every
//      custom control carries a VoiceOver label (the colour swatches and the "Clear" buttons read
//      out what they do, not just "button").
//  External Types:
//      FilterState, FilterSort, LegalityFilter, SetInfo, SetsFilterWidget

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

/// Which fields are relevant for the current caller.
enum FilterContext {
    case scryfall
    case collection  // My Hold or a Binder
    case deck        // a deck board — collection controls plus the legality filter
}

struct FilterSheetView: View {

    // MARK: Stored Properties

    var context: FilterContext
    /// Title for the top context section, e.g. "My Hold", "Binder", "Deck".
    var collectionTitle: String = "Collection"
    var onApply: () -> Void

    let allColors = ["W", "U", "B", "R", "G"]
    let allTypes = ["Creature", "Instant", "Sorcery", "Artifact", "Enchantment", "Land", "Planeswalker"]
    let allRarities = ["common", "uncommon", "rare", "mythic", "special"]
    let formats = ["standard", "modern", "legacy", "vintage", "commander", "pauper", "pioneer"]
    /// Scryfall `is:` printing flags, with display labels. Search exposes the full set; collection
    /// contexts only offer flags we cache locally on `Card` (just `reserved`).
    private var printOptions: [(flag: String, label: String)] {
        if isScryfall {
            return [("foil", "Foil"), ("fullart", "Full Art"), ("reprint", "Reprint"),
                    ("reserved", "Reserved List"), ("promo", "Promo"), ("textless", "Textless")]
        }
        return [("reserved", "Reserved List")]
    }
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

                // Context controls at the top, titled by the caller.
                if isDeck {
                    deckSection
                } else if !isScryfall {
                    collectionSection
                }

                // Below the context controls the sheet mirrors the Search (Scryfall) layout in the
                // same order — collection contexts run the same filters locally over cached card
                // data. The only trim is the Printing section (see printOptions: collection lacks
                // local data for full-art/reprint/promo/textless, so only Reserved List is offered).
                sortSection
                colorsSection
                colorIdentitySection
                typesSection
                raritiesSection
                cmcSection
                powerToughnessSection
                producedManaSection
                formatSection
                printingSection
                textSection
                priceSection
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

    // MARK: Context sections

    private var resetSection: some View {
        Section {
            HStack {
                Spacer()
                Button("Reset") { filters.reset() }
                    .bold()
                    .accessibilityLabel("Reset all filters")
                Spacer()
            }
        }
    }

    /// My Hold / Binder controls.
    private var collectionSection: some View {
        Section(collectionTitle) {
            Toggle("Favourites only", isOn: $filters.favouritesOnly)
            finishPills
        }
    }

    /// Deck controls: the collection toggles plus the board legality filter.
    private var deckSection: some View {
        Section(collectionTitle) {
            Picker("Legality", selection: $filters.legality) {
                ForEach(LegalityFilter.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            Toggle("Favourites only", isOn: $filters.favouritesOnly)
            finishPills
        }
    }

    /// Finish pill chips: Base / Foil / Etched. Multiple can be selected; empty = all.
    @ViewBuilder
    private var finishPills: some View {
        let finishOptions: [(raw: String, label: String)] = [
            (CardFinish.nonfoil.rawValue, "Base"),
            (CardFinish.foil.rawValue, "Foil"),
            (CardFinish.etched.rawValue, "Etched"),
        ]
        VStack(alignment: .leading, spacing: 6) {
            Text("Finish")
                .font(.footnote)
                .foregroundStyle(.secondary)
            HStack(spacing: 8) {
                ForEach(finishOptions, id: \.raw) { opt in
                    let selected = filters.finishes.contains(opt.raw)
                    Button {
                        toggle(array: &filters.finishes, value: opt.raw)
                    } label: {
                        Text(opt.label)
                            .font(.subheadline)
                            .foregroundColor(selected ? .white : tint)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(selected ? tint : Color.clear, in: Capsule())
                            .overlay(Capsule().strokeBorder(tint.opacity(selected ? 0 : 0.35), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(opt.label)
                    .accessibilityAddTraits(selected ? [.isSelected] : [])
                }
            }
        }
        .padding(.vertical, 4)
    }

    // MARK: Shared sections

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
                ForEach(allColors, id: \.self) { colorSwatch($0, in: $filters.colors) }
            }
            clearButton("Clear colours") { filters.colors = [] }
        }
    }

    private var colorIdentitySection: some View {
        Section {
            HStack {
                ForEach(allColors, id: \.self) { colorSwatch($0, in: $filters.colorIdentity) }
            }
            clearButton("Clear colour identity") { filters.colorIdentity = [] }
        } header: {
            Text("Colour Identity")
        } footer: {
            Text("Commander colour identity — cards that fit within the selected colours.")
        }
    }

    private var typesSection: some View {
        Section("Types") {
            chipGrid(all: allTypes, selected: filters.types,
                     toggle: { toggle(array: &filters.types, value: $0) }, label: { $0 })
            clearButton("Clear types") { filters.types = [] }
        }
    }

    private var raritiesSection: some View {
        Section("Rarities") {
            chipGrid(all: allRarities, selected: filters.rarities,
                     toggle: { toggle(array: &filters.rarities, value: $0) }, label: { $0.capitalized })
            clearButton("Clear rarities") { filters.rarities = [] }
        }
    }

    private var cmcSection: some View {
        Section("Mana Value") {
            HStack(spacing: 40) {
                Text("Min: \(Int(filters.cmcLower))")
                Text("Max: \(Int(filters.cmcUpper))")
            }
            Slider(value: $filters.cmcLower, in: 0...20, step: 1)
                .accessibilityLabel("Minimum mana value")
            Slider(value: $filters.cmcUpper, in: 0...20, step: 1)
                .accessibilityLabel("Maximum mana value")
            if filters.cmcLower > filters.cmcUpper {
                Text("Min can't exceed Max")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            clearButton("Clear mana value range") {
                filters.cmcLower = 0
                filters.cmcUpper = 20
            }
        }
    }

    // MARK: Scryfall-only sections

    private var powerToughnessSection: some View {
        Section("Power & Toughness") {
            HStack {
                Text("Power")
                Spacer()
                Text(rangeLabel(filters.powerLower, filters.powerUpper, cap: 15)).foregroundStyle(.secondary)
            }
            Slider(value: $filters.powerLower, in: 0...15, step: 1).accessibilityLabel("Minimum power")
            Slider(value: $filters.powerUpper, in: 0...15, step: 1).accessibilityLabel("Maximum power")
            HStack {
                Text("Toughness")
                Spacer()
                Text(rangeLabel(filters.toughnessLower, filters.toughnessUpper, cap: 15)).foregroundStyle(.secondary)
            }
            Slider(value: $filters.toughnessLower, in: 0...15, step: 1).accessibilityLabel("Minimum toughness")
            Slider(value: $filters.toughnessUpper, in: 0...15, step: 1).accessibilityLabel("Maximum toughness")
            clearButton("Clear power and toughness") {
                filters.powerLower = 0; filters.powerUpper = 15
                filters.toughnessLower = 0; filters.toughnessUpper = 15
            }
        }
    }

    private var producedManaSection: some View {
        Section("Produces Mana") {
            HStack {
                ForEach(allColors, id: \.self) { colorSwatch($0, in: $filters.producedMana) }
            }
            clearButton("Clear produced mana") { filters.producedMana = [] }
        }
    }

    private var formatSection: some View {
        Section("Format & Commander") {
            Picker("Legal in", selection: $filters.formatLegality) {
                Text("Any").tag("")
                ForEach(formats, id: \.self) { Text($0.capitalized).tag($0) }
            }
            Toggle("Can be Commander", isOn: $filters.isCommander)
        }
    }

    private var printingSection: some View {
        Section("Printing") {
            chipGrid(all: printOptions.map(\.flag), selected: filters.printFlags,
                     toggle: { toggle(array: &filters.printFlags, value: $0) },
                     label: { printLabel($0) })
            clearButton("Clear printing options") { filters.printFlags = [] }
        }
    }

    private var textSection: some View {
        Section("Text & Artist") {
            TextField("Rules text contains", text: $filters.oracleText)
                .autocorrectionDisabled()
            TextField("Keyword (e.g. flying)", text: $filters.keyword)
                .autocorrectionDisabled()
            TextField("Artist", text: $filters.artist)
        }
    }

    private var priceSection: some View {
        Section {
            HStack {
                Text("Max price")
                Spacer()
                Text(filters.priceMaxUSD > 0 ? "$\(Int(filters.priceMaxUSD))" : "Any").foregroundStyle(.secondary)
            }
            Slider(value: $filters.priceMaxUSD, in: 0...100, step: 1)
                .accessibilityLabel("Maximum price in US dollars")
            clearButton("Clear max price") { filters.priceMaxUSD = 0 }
        } header: {
            Text("Price")
        } footer: {
            Text("Show cards at or below this USD price. Any means no limit.")
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
            clearButton("Clear sets") { filters.sets = [] }
        }
    }

    // MARK: Reusable controls

    /// A colour mana swatch that toggles its value in `selection`. Pill highlight + VoiceOver label.
    private func colorSwatch(_ color: String, in selection: Binding<[String]>) -> some View {
        let selected = selection.wrappedValue.contains(color)
        return Button {
            if let i = selection.wrappedValue.firstIndex(of: color) {
                selection.wrappedValue.remove(at: i)
            } else {
                selection.wrappedValue.append(color)
            }
        } label: {
            OracleSymbolImage(symbol: "{\(color)}", size: 44)
                .padding(6)
                .background(selected ? tint.opacity(0.25) : Color.clear, in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(colorName(color))
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }

    /// A pill chip grid (selected = filled tint pill, unselected = outlined pill).
    @ViewBuilder
    private func chipGrid(all: [String], selected: [String],
                          toggle: @escaping (String) -> Void,
                          label: @escaping (String) -> String) -> some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(all, id: \.self) { value in
                let contains = selected.contains(value)
                Button {
                    toggle(value)
                } label: {
                    Text(label(value))
                        .foregroundColor(contains ? .white : tint)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 32)
                        .padding(.horizontal, 10)
                        .background(contains ? tint : Color.clear, in: Capsule())
                        .overlay(Capsule().strokeBorder(tint.opacity(contains ? 0 : 0.35), lineWidth: 1))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(label(value))
                .accessibilityAddTraits(contains ? [.isSelected] : [])
            }
        }
    }

    /// A destructive "Clear" button whose VoiceOver label says *what* it clears.
    private func clearButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button("Clear", role: .destructive, action: action)
            .accessibilityLabel(label)
    }

    // MARK: Helpers

    func toggle(array: inout [String], value: String) {
        if let index = array.firstIndex(of: value) {
            array.remove(at: index)
        } else {
            array.append(value)
        }
    }

    private func colorName(_ symbol: String) -> String {
        switch symbol {
        case "W": return "White"
        case "U": return "Blue"
        case "B": return "Black"
        case "R": return "Red"
        case "G": return "Green"
        default:  return symbol
        }
    }

    private func printLabel(_ flag: String) -> String {
        printOptions.first { $0.flag == flag }?.label ?? flag.capitalized
    }

    /// "Any" for a full range, else "lo to hi" (or "lo to cap+" at the top).
    private func rangeLabel(_ lo: Double, _ hi: Double, cap: Int) -> String {
        if lo == 0 && Int(hi) >= cap { return "Any" }
        let hiStr = Int(hi) >= cap ? "\(cap)+" : "\(Int(hi))"
        return "\(Int(lo)) to \(hiStr)"
    }
}
