//
//  EditDeckSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-06.
//  Purpose:
//      Allows the user to chnage properties for the respective deck
//  External Types:
//      Deck, ImageManager, CameraPicker, PhotoLibraryPicker

// MARK: Imports

import SwiftUI

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
    @Bindable var deck: Deck
    @State var name: String
    @State var ruleType: String
    @State var selectedImage: UIImage?
    @State var pinned: Bool
    @State var showPreviews: Bool
    @State var showControls: Bool
    @State var showCover: Bool
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false
    
    // MARK: Initializer
    
    init(deck: Deck) {
        self.deck = deck
        self.name = deck.name
        self.ruleType = deck.ruleType
        self.pinned = deck.pinned
        self.showPreviews = deck.showPreviews
        self.showControls = deck.showControls
        self.showCover = deck.showCover
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
                            .padding(.bottom, 20)
                        
                        Picker("Rule Type", selection: $ruleType) {
                            ForEach(legalities, id: \.self) { legality in
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
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save"){
                        dismiss()
                    }
                }
            })
            .navigationTitle("Edit Deck")
            .onDisappear() {
                deck.name = $name.wrappedValue
                deck.ruleType = $ruleType.wrappedValue
                deck.pinned = $pinned.wrappedValue
                deck.showPreviews = $showPreviews.wrappedValue
                deck.showControls = $showControls.wrappedValue
                deck.showCover = $showCover.wrappedValue
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
                    ImageManager.saveImage(forImage: image, withIdentifier: deck.id)
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
                    selectedImage = ImageManager.fetchImage(withIdentifier: deck.id)
                }
            }
        }
    }
}

