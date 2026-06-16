//
//  NewDeckSheet.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-26.
//  Purpose:
//      Allows the user to create a new deck instance, optionally importing a deck list (Phase 5
//      import engine). Pasted text is parsed live for a preview; on Create the lines are resolved
//      against Scryfall and added to the new deck's boards.
//  External Types:
//      Deck, CardEntry, ImageManager, CameraPicker, PhotoLibraryPicker, Spotlight,
//      DeckImportViewModel, DeckBoard, CardStore, SFAPI, StatsUpdater
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct NewDeckSheet: View {

    // MARK: Stored Properties

    /// list of Scryfall legality types
    let legalities = [
        "standard",
        "modern",
        "legacy",
        "vintage",
        "pauper",
        "casual",
        "commander",
        "oathbreaker",
        "historic",
        "alchemy",
        "pioneer",
        "explorer",
        "brawl",
        "future",
        "oldschool",
        "premodern",
        "penny"
    ]

    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var name: String = ""
    @State var coverImage: String = ""
    @State var ruleType: String = "casual"
    @State var selectedImage: UIImage?
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false

    @StateObject private var importVM = DeckImportViewModel()
    @State private var isCreating = false

    // MARK: Derived Data

    /// Live, network-free preview of the parsed import grouped by board.
    private var boardSummary: [(board: DeckBoard, count: Int)] {
        let order: [DeckBoard] = [.commander, .mainboard, .sideboard, .maybeboard]
        return order.compactMap { board in
            let count = importVM.parsedLines
                .filter { $0.board == board }
                .reduce(0) { $0 + $1.quantity }
            return count > 0 ? (board, count) : nil
        }
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                Section("Deck Information") {
                    VStack(alignment: .center, spacing: 20) {
                        ZStack(alignment: .center) {
                            Color.gray
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                            Image(uiImage: selectedImage ?? UIImage(named: "MtgDeck")!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)

                            Image(systemName: "camera.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .shadow(radius: 4)
                                .onTapGesture(count: 1, perform: {
                                    showSourceSelection.toggle()
                                })
                        }
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.center)

                        Picker("Rule Type", selection: $ruleType) {
                            ForEach(legalities, id: \.self) { legality in
                                Text(legality.capitalized)
                                    .tag(legality)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding(.top, 20)
                }

                Section("Import Cards (Optional)") {
                    ZStack(alignment: .topLeading) {
                        if importVM.rawText.isEmpty {
                            Text("Paste a deck list…\n4 Lightning Bolt\n2 Counterspell\n\nSideboard\n3 Negate")
                                .foregroundStyle(.secondary)
                                .font(.callout)
                                .padding(.top, 8)
                                .padding(.leading, 4)
                                .allowsHitTesting(false)
                        }
                        TextEditor(text: $importVM.rawText)
                            .frame(minHeight: 140)
                            .onChange(of: importVM.rawText) { _, _ in
                                importVM.parse()
                            }
                    }

                    if !boardSummary.isEmpty {
                        ForEach(boardSummary, id: \.board) { item in
                            HStack {
                                Text(item.board.rawValue.capitalized)
                                Spacer()
                                Text("\(item.count) cards")
                                    .foregroundStyle(.secondary)
                            }
                            .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("New Deck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(isCreating)
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isCreating {
                        ProgressView()
                    } else {
                        Button("Create") {
                            Task { await saveDeck() }
                        }
                        .disabled(name.isEmpty)
                    }
                }
            }
            .confirmationDialog("Select Source",isPresented: $showSourceSelection, actions:{
                Button("Camera"){
                    photoSource = .camera
                    showImagePicker.toggle()
                }
                Button("Photo Library"){
                    photoSource = .photoLibrary
                    showImagePicker.toggle()
                }
            }
            )
            .fullScreenCover(isPresented: $showImagePicker) {
                if photoSource == .camera{
                    CameraPicker(image: $selectedImage)
                        .ignoresSafeArea()
                } else {
                    PhotoLibraryPicker(image: $selectedImage)
                }
            }
        }
    }

    // MARK: saveDeck

    private func saveDeck() async {
        let deck = Deck(name: name, notes: "", ruleType: ruleType)

        if let image = selectedImage {
            ImageManager.saveImage(forImage: image, withIdentifier: deck.id)
        }

        Spotlight.indexData(id: deck.id, name: deck.name, image: ImageManager.fetchImage(withIdentifier: deck.id), description: "Deck in your collection.")
        modelContext.insert(deck)

        // Optional deck-list import: resolve against Scryfall and fill the boards.
        if !importVM.rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isCreating = true
            await importVM.resolve()

            // Cache resolved card data so entries resolve later.
            let cards = importVM.result.resolved.map { SFAPI.JSONtoModel(json: $0.card) }
            CardStore.cache(cards, context: modelContext)

            for resolved in importVM.result.resolved {
                guard let cardID = resolved.card.id else { continue }
                let entry = CardEntry(scryfallCardID: cardID, quantity: resolved.line.quantity)
                switch resolved.line.board {
                case .mainboard: deck.mainboard.append(entry)
                case .sideboard: deck.sideboard.append(entry)
                case .maybeboard: deck.maybeboard.append(entry)
                case .commander: deck.commander = entry
                }
            }

            StatsUpdater.update(deck, context: modelContext)
            isCreating = false
        }

        dismiss()
    }
}
