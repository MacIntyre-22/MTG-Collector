//
//  EditBinderSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-03.
//

import SwiftUI

struct EditBinderSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var binder: Binder
    
    @State var name: String
    @State var selectedImage: UIImage
    @State var pinned: Bool = false
    @State var showPreviews: Bool = false
    @State var showControls: Bool = false
    @State var showCover: Bool = false

    
    // for image
    @State var showSourceSelection = false
    @State var photoSource: UIImagePickerController.SourceType = .photoLibrary

    @State private var showImagePicker = false
    
    init(binder: Binder) {
        self.binder = binder
        self.name = binder.name
        self.pinned = binder.pinned
        self.showPreviews = binder.showPreviews
        self.showControls = binder.showControls
        self.showCover = binder.showCover
        self.selectedImage = ImageManager.fetchImage(withIdentifier: binder.id) ?? UIImage(named: "MtgBinder")!
    }

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
            .navigationTitle("Edit Binder")
            .onDisappear() {
                // set binder values
                binder.name = $name.wrappedValue
                binder.pinned = $pinned.wrappedValue
                binder.showPreviews = $showPreviews.wrappedValue
                binder.showControls = $showControls.wrappedValue
                binder.showCover = $showCover.wrappedValue
                
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
                // save image
                ImageManager.saveImage(forImage: selectedImage, withIdentifier: binder.id)
            } content: {
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
}

