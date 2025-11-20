//
//  NewBinderSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//      Allows the user to create a new binder instance
//  External Types:
//      Binder, ImageManager, CameraPicker, PhotoLibraryPicker, Spotlight

// MARK: Imports

import SwiftUI

// MARK: Types

struct NewBinderSheet: View {

    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State private var name: String = ""
    @State var selectedImage: UIImage?
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImagePicker = false

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
                                Image(uiImage: selectedImage ?? UIImage(named: "MtgBinder")!)
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
            }
            .navigationTitle("New Binder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        saveBinder()
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

    // MARK: saveBinder
    private func saveBinder() {
        let binder = Binder(name: name, notes: "")
        if let image = selectedImage {
            ImageManager.saveImage(forImage: image, withIdentifier: binder.id)
        }
        
        Spotlight.indexData(id: binder.id, name: binder.name, image: ImageManager.fetchImage(withIdentifier: binder.id), description: "Binder in your collection.")
        modelContext.insert(binder)
        dismiss()
    }
}
