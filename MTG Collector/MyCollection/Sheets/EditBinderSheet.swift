//
//  EditBinderSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-03.
//  Purpose:
//      Allows the user to chnage properties for the respective binder
// External Types:
//      Binder, ImageManager, CameraPicker, PhotoLibraryPicker

// MARK: Imports

import SwiftUI

// MARK: Types

struct EditBinderSheet: View {
    
    // MARK: Stored Properties
    
    var binder: Binder
    /// Called when the user confirms deletion (the presenter performs the delete + any navigation).
    var onDelete: (() -> Void)? = nil

    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var name: String
    @State var selectedImage: UIImage? = nil
    @State var pinned: Bool
    @State var showPreviews: Bool
    @State var showControls: Bool
    @State var showCover: Bool
    @State var inCollection: Bool
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false
    @State private var showDeleteAlert = false
    /// When deleting, skip the onDisappear save so we don't write to a removed binder.
    @State private var isDeleting = false

    // MARK: Initializer

    init(binder: Binder, onDelete: (() -> Void)? = nil) {
        self.binder = binder
        self.onDelete = onDelete
        self.name = binder.name
        self.pinned = binder.pinned
        self.showPreviews = binder.showPreviews
        self.showControls = binder.showControls
        self.showCover = binder.showCover
        self.inCollection = binder.inCollection
        /// image init is in onAppear
    }
    
    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                Section("Binder Information") {
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
                        }
                        .padding(.top, 20)
                }
                Section("Controls") {
                    Toggle("Pinned", isOn: $pinned)
                    Toggle("Previews", isOn: $showPreviews)
                    Toggle("Controls", isOn: $showControls)
                    Toggle("Cover Image", isOn: $showCover)
                }
                Section {
                    Toggle("Count in Collection Totals", isOn: $inCollection)
                } footer: {
                    Text("Include this binder's cards in your whole-collection value and counts.")
                }
                if onDelete != nil {
                    Section {
                        Button("Delete Binder", role: .destructive) {
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
            .navigationTitle("Edit Binder")
            .alert("Delete Binder?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    isDeleting = true
                    dismiss()
                    onDelete?()
                }
            } message: {
                Text("This permanently removes “\(name)” and its card list. This can't be undone.")
            }
            .onDisappear() {
                guard !isDeleting else { return }
                binder.name = $name.wrappedValue
                binder.pinned = $pinned.wrappedValue
                binder.showPreviews = $showPreviews.wrappedValue
                binder.showControls = $showControls.wrappedValue
                binder.showCover = $showCover.wrappedValue
                binder.inCollection = $inCollection.wrappedValue
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
                    binder.setCover(image)
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
                    selectedImage = binder.coverUIImage
                }
            }
        }
    }
}

