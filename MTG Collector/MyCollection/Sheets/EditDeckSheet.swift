//
//  EditDeckSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-06.
//  Purpose:
//      Allows the user to chnage properties for the respective deck
//  External Types:
//      Deck, ImageManager, CameraPicker, PhotoLibraryPicker

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct EditDeckSheet: View {
    
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
    @Environment(\.modelContext) private var modelContext
    @Bindable var deck: Deck
    /// Called when the user confirms deletion (the presenter performs the delete + any navigation).
    var onDelete: (() -> Void)? = nil
    @State var name: String
    @State var ruleType: String
    @State var selectedImage: UIImage?
    @State var pinned: Bool
    @State var showPreviews: Bool
    @State var showControls: Bool
    @State var showCover: Bool
    @State var inCollection: Bool
    @State var colorIdentity: [String]
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false
    @State private var showDeleteAlert = false
    /// When deleting, skip the onDisappear save so we don't write to a removed deck.
    @State private var isDeleting = false

    private let allColors = ["W", "U", "B", "R", "G"]

    // MARK: Initializer

    init(deck: Deck, onDelete: (() -> Void)? = nil) {
        self.deck = deck
        self.onDelete = onDelete
        self.name = deck.name
        self.ruleType = deck.ruleType
        self.pinned = deck.pinned
        self.showPreviews = deck.showPreviews
        self.showControls = deck.showControls
        self.showCover = deck.showCover
        self.inCollection = deck.inCollection
        self.colorIdentity = deck.colorIdentity
        /// set image in on appear
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
                            Image(uiImage: selectedImage ?? UIImage(named: "CardholdIcon")!)
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
                            .padding(.bottom, 20)
                        
                        Picker("Rule Type", selection: $ruleType) {
                            ForEach(legalities.sorted(), id: \.self) { legality in
                                Text(legality.capitalized)
                                    .tag(legality)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                }
                .padding(.top, 20)
                    
                Section("Controls") {
                    Toggle("Pinned", isOn: $pinned)
                    Toggle("Previews", isOn: $showPreviews)
                    Toggle("Controls", isOn: $showControls)
                    Toggle("Cover Image", isOn: $showCover)
                }
                Section {
                    Toggle("Count in Collection Totals", isOn: $inCollection)
                } footer: {
                    Text("Include this deck's cards in your whole-collection value and counts. Off by default, since a deck is a build, not owned stock.")
                }

                Section {
                    HStack {
                        ForEach(allColors, id: \.self) { colour in
                            Button {
                                if colorIdentity.contains(colour) {
                                    colorIdentity.removeAll { $0 == colour }
                                } else {
                                    colorIdentity = allColors.filter { colorIdentity.contains($0) || $0 == colour }
                                }
                            } label: {
                                OracleSymbolImage(symbol: "{\(colour)}", size: 44)
                                    .padding(5)
                                    .background(colorIdentity.contains(colour) ? .gray.opacity(0.18) : .clear)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Button("Clear", role: .destructive) { colorIdentity = [] }
                } header: {
                    Text("Colour Identity")
                } footer: {
                    Text("Set automatically from the deck's leader. Designating a new leader resets these to the leader's colours.")
                }

                if onDelete != nil {
                    Section {
                        Button("Delete Deck", role: .destructive) {
                            showDeleteAlert = true
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save"){
                        dismiss()
                    }
                }
            })
            .navigationTitle("Edit Deck")
            .alert("Delete Deck?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    isDeleting = true
                    dismiss()
                    onDelete?()
                }
            } message: {
                Text("This permanently removes “\(name)” and its card lists. This can't be undone.")
            }
            .onDisappear() {
                guard !isDeleting else { return }
                let ruleChanged = deck.ruleType != ruleType
                deck.name = name
                deck.ruleType = ruleType
                deck.pinned = pinned
                deck.showPreviews = showPreviews
                deck.showControls = showControls
                deck.showCover = showCover
                deck.inCollection = inCollection
                deck.colorIdentity = colorIdentity

                // Switching game mode invalidates the leader slots — clear them (cards return to the
                // mainboard) and re-derive colours. This wins over a manual colour edit above.
                if ruleChanged {
                    deck.resetLeaders()
                    DeckColors.refresh(deck, context: modelContext)
                    StatsUpdater.update(deck, context: modelContext)
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
                if let image = selectedImage {
                    deck.setCover(image)
                }
            } content: {
                if photoSource == .camera{
                    CameraPicker(image: $selectedImage)
                        .ignoresSafeArea()
                } else {
                    PhotoLibraryPicker(image: $selectedImage)
                }
            }
            .onAppear {
                if selectedImage == nil {
                    selectedImage = deck.coverUIImage
                }
            }
        }
    }
}

