//
//  ImportCardsSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Adds cards to an existing deck or binder from pasted text or a picked .txt / .csv file.
//      Reuses the deck-import engine (parse → resolve against Scryfall) and CollectionImportBuilder
//      to append the matched cards, showing matched / unresolved counts before committing.
//  External Types:
//      Deck, Binder, DeckImportViewModel, CollectionImportBuilder, CardStore
//

// MARK: Imports

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

// MARK: Target

/// What an import appends to.
enum ImportTarget {
    case deck(Deck)
    case binder(Binder)

    var isDeck: Bool { if case .deck = self { return true } else { return false } }
}

// MARK: Sheet

struct ImportCardsSheet: View {

    let target: ImportTarget
    /// Optional list to seed the editor with (e.g. a .txt / .csv opened from Files routed to My Hold).
    var initialText: String = ""

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @StateObject private var importVM = DeckImportViewModel()
    @State private var showFileImporter = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Paste a list") {
                    ZStack(alignment: .topLeading) {
                        if importVM.rawText.isEmpty {
                            Text("4 Lightning Bolt\n2 Counterspell\n\nor a CSV export…")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                        }
                        TextEditor(text: $importVM.rawText)
                            .frame(minHeight: 120)
                            .onChange(of: importVM.rawText) { _, _ in
                                importVM.sourceFilename = nil
                                importVM.parse()
                            }
                    }

                    Button {
                        showFileImporter = true
                    } label: {
                        Label("Import .txt / .csv File", systemImage: "doc.text")
                    }
                }

                if !importVM.parsedLines.isEmpty {
                    Section("Preview") {
                        LabeledContent("Lines", value: "\(importVM.parsedLines.count)")
                        if importVM.hasResolved {
                            LabeledContent("Matched", value: "\(importVM.resolvedCount)")
                            if importVM.unresolvedCount > 0 {
                                LabeledContent("Not found", value: "\(importVM.unresolvedCount)")
                                    .foregroundStyle(.orange)
                            }
                        }
                    }

                    if importVM.hasResolved && !importVM.result.unresolved.isEmpty {
                        Section("Couldn't find") {
                            ForEach(importVM.result.unresolved) { line in
                                Text(line.name).font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Import Cards")
            .onAppear {
                // Seed a list routed in from Files (parse fires here; resolve stays user-driven).
                if importVM.rawText.isEmpty, !initialText.isEmpty {
                    importVM.rawText = initialText
                    importVM.parse()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if importVM.isResolving {
                        ProgressView()
                    } else if importVM.hasResolved {
                        Button("Add \(importVM.resolvedCount)") { commit() }
                            .disabled(importVM.resolvedCount == 0)
                    } else {
                        Button("Match") { Task { await importVM.resolve() } }
                            .disabled(importVM.parsedLines.isEmpty)
                    }
                }
            }
            .fileImporter(isPresented: $showFileImporter,
                          allowedContentTypes: [.plainText, .commaSeparatedText, .text],
                          allowsMultipleSelection: false) { result in
                loadFile(result)
            }
        }
    }

    // MARK: Actions

    private func commit() {
        switch target {
        case .deck(let deck):
            CollectionImportBuilder.add(importVM.result.resolved, to: deck, context: modelContext)
        case .binder(let binder):
            CollectionImportBuilder.add(importVM.result.resolved, to: binder, context: modelContext)
        }
        let ids = importVM.result.resolved.compactMap { $0.card.id }
        Task { await CardStore.prime(ids, context: modelContext) }
        HapticManager.success()
        dismiss()
    }

    private func loadFile(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result, let url = urls.first else { return }
        guard url.startAccessingSecurityScopedResource() else { HapticManager.error(); return }
        defer { url.stopAccessingSecurityScopedResource() }
        if let text = try? String(contentsOf: url, encoding: .utf8) {
            importVM.rawText = text
            importVM.sourceFilename = url.lastPathComponent
            importVM.parse()
        } else {
            // Couldn't read the picked file as text — let the user know something went wrong.
            HapticManager.error()
        }
    }
}
