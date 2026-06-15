//
//  CollectionExportSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Lets the user export a binder or deck as plain text (Moxfield/Archidekt compatible) or
//      CSV, then share it via the iOS share sheet or copy it. Card data is resolved from the
//      local cache (CardStore); cards not yet cached fall back to their ID.
//  External Types:
//      CollectionExporter, CardEntry, Deck, Card, CardStore

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CollectionExportSheet: View {

    enum Format: String, CaseIterable, Identifiable {
        case text = "Text"
        case csv = "CSV"
        var id: String { rawValue }
    }

    // MARK: Stored Properties

    /// Provide a deck for sectioned text export; otherwise a flat entry list (binder).
    var deck: Deck?
    var entries: [CardEntry]
    var title: String

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var format: Format = .text
    @State private var lookup: [String: Card] = [:]
    @State private var output: String = ""

    // MARK: View

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Picker("Format", selection: $format) {
                    ForEach(Format.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)

                ScrollView {
                    Text(output.isEmpty ? "Nothing to export." : output)
                        .font(.system(.footnote, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                        .padding()
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

                HStack {
                    Button {
                        UIPasteboard.general.string = output
                    } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }
                    .buttonStyle(.bordered)

                    ShareLink(item: output) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(output.isEmpty)
                }
            }
            .padding()
            .navigationTitle("Export \(title)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .task {
                lookup = CardStore.lookup(for: entries.map { $0.scryfallCardID }, context: modelContext)
                rebuild()
            }
            .onChange(of: format) { _, _ in rebuild() }
        }
    }

    // MARK: Build output

    private func rebuild() {
        switch format {
        case .text:
            output = deck != nil
                ? CollectionExporter.deckText(deck!, lookup: lookup)
                : CollectionExporter.plainText(entries, lookup: lookup)
        case .csv:
            output = CollectionExporter.csv(entries, lookup: lookup)
        }
    }
}
