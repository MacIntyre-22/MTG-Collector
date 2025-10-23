//
//  NewBinderSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct NewBinderSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext

    // user input for new binder
    @State private var name: String = ""
    @State var selectedImage: UIImage = UIImage(named: "MtgBinder")!
    
    // for image
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var showImagePicker = false

    var body: some View {
        NavigationStack {
            Form {
                // edit binder form
                Section("Binder Information") {
                    
                        VStack(alignment: .center, spacing: 20) {
                            ZStack(alignment: .center) {
                                Color.gray
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(10)
                                Image(uiImage: selectedImage)
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
                        // save binder
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
                    //load the photopicker
                    PhotoLibraryPicker(image: $selectedImage)
                }
            }
        }
    }

    // MARK: saveBinder
    private func saveBinder() {
        // make binder model instance
        let binder = Binder(name: name, notes: "")
        
        // save image
        ImageManager.saveImage(forImage: selectedImage, withIdentifier: binder.id)
        
        // save and dismiss
        modelContext.insert(binder)
        dismiss()
    }
}
