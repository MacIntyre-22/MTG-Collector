//
//  NewDeckSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-26.
//  Purpose:
//      Allows the user to create a new deck instance
//  External Types:
//      Deck, ImageManager, CameraPicker, PhotoLibraryPicker, Spotlight

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
            }
            .navigationTitle("New Deck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        saveDeck()
                    }
                    .disabled(name.isEmpty)
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
    private func saveDeck() {
        let deck = Deck(name: name, notes: "", ruleType: ruleType)
        
        if let image = selectedImage {
            ImageManager.saveImage(forImage: image, withIdentifier: deck.id)
        }
        
        Spotlight.indexData(id: deck.id, name: deck.name, image: ImageManager.fetchImage(withIdentifier: deck.id), description: "Deck in your collection.")
        modelContext.insert(deck)
        dismiss()
    }
}

