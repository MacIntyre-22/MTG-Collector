//
//  NewDeckSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-26.
//

import SwiftUI

struct NewDeckSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    // data

    // user input for new deck
    @State var name: String = ""
    @State var coverImage: String = ""
    // default to casual, no legalities
    @State var ruleType: String = "casual"
    
    @State var selectedImage: UIImage?
    
    // for image
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showImagePicker = false
    
    // list of Scryfall legality types
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

    var body: some View {
        NavigationStack {
            Form {
                // deck form
                Section("Deck Information") {
                    VStack(alignment: .center, spacing: 20) {
                        ZStack(alignment: .center) {
                            Color.gray
                                .frame(width: 200, height: 200)
                                .cornerRadius(10)
                            // if image is nill display default
                            // i can force because i know it exists
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
                        
                        // select rule type from array of legalities
                        Picker("Rule Type", selection: $ruleType) {
                            ForEach(legalities, id: \.self) { legality in
                                // capitalize for display
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
                        // save deck
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
                    //load the photopicker
                    PhotoLibraryPicker(image: $selectedImage)
                }
            }
        }
    }

    // MARK: saveDeck
    private func saveDeck() {
        // make a deck model instance
        let deck = Deck(name: name, notes: "", ruleType: ruleType)
        
        // save image
        if let image = selectedImage {
            ImageManager.saveImage(forImage: image, withIdentifier: deck.id)
        }
        
        // index into spotlight search
        Spotlight.indexData(id: deck.id, name: deck.name, image: ImageManager.fetchImage(withIdentifier: deck.id), description: "Deck in your collection.")
        
        
        // save and dismiss
        modelContext.insert(deck)
        dismiss()
    }
}

