//
//  SetsFilterWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-16.
//  Purpose:
//      Entry row that opens a searchable sheet of every set. The old Menu-based picker
//      only showed four set types and lagged badly; a `List` virtualises rows so all sets
//      can be shown and searched instantly, grouped by release year or by set type.
//  External Types:
//      SetInfo
//

// MARK: Imports

import SwiftUI
import SwiftData
import UIKit

// MARK: Types

struct SetsFilterWidget: View {

    // MARK: Stored Properties

    /// Currently selected set codes (so the sheet can show checkmarks).
    var selected: [String]
    /// Toggles a set code in/out of the active filter.
    var action: (String) -> Void

    // MARK: State Properties

    @State private var showSheet = false

    // MARK: View

    var body: some View {
        Button {
            showSheet = true
        } label: {
            HStack {
                Text("Browse Sets")
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showSheet) {
            SetsFilterSheet(selected: selected, action: action)
        }
    }
}

// MARK: Searchable Sets Sheet

struct SetsFilterSheet: View {

    // MARK: Grouping

    enum Grouping: String, CaseIterable, Identifiable {
        case year = "Year"
        case type = "Type"
        var id: String { rawValue }
    }

    // MARK: Stored Properties

    var selected: [String]
    var action: (String) -> Void

    // MARK: State Properties

    @Environment(\.dismiss) private var dismiss
    @Query private var sets: [SetInfo]
    @State private var searchText = ""
    @State private var grouping: Grouping = .year

    // MARK: Derived Data

    /// Sets matching the search text (name or code).
    private var filtered: [SetInfo] {
        guard !searchText.isEmpty else { return sets }
        return sets.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.code.localizedCaseInsensitiveContains(searchText)
        }
    }

    /// Sets grouped into titled sections, ordered for display.
    private var groups: [(title: String, sets: [SetInfo])] {
        switch grouping {
        case .year:
            let dict = Dictionary(grouping: filtered) { String($0.releaseDate.prefix(4)) }
            return dict.keys.sorted(by: >).map { key in
                (key.isEmpty ? "Unknown" : key, dict[key]!.sorted { $0.name < $1.name })
            }
        case .type:
            let dict = Dictionary(grouping: filtered) { $0.type }
            return dict.keys.sorted().map { key in
                (prettyType(key), dict[key]!.sorted { $0.name < $1.name })
            }
        }
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            List {
                ForEach(groups, id: \.title) { group in
                    Section(group.title) {
                        ForEach(group.sets) { set in
                            Button {
                                action(set.code)
                            } label: {
                                HStack {
                                    icon(for: set)
                                    Text(set.name)
                                    Spacer()
                                    if selected.contains(set.code) {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.tint)
                                    }
                                }
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search sets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Picker("Group", selection: $grouping) {
                        ForEach(Grouping.allCases) { Text($0.rawValue).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    .frame(maxWidth: 200)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    // MARK: Helpers

    /// Set logo if bundled, otherwise the generic app logo.
    @ViewBuilder
    private func icon(for set: SetInfo) -> some View {
        Image(UIImage(named: set.code) != nil ? set.code : "Logo")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(.primary)
    }

    /// Turns a raw Scryfall set_type (e.g. "draft_innovation") into a display label.
    private func prettyType(_ raw: String) -> String {
        raw.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
