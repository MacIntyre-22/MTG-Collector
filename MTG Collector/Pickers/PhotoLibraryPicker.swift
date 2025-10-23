//
//  PhotoLibraryPicker.swift
//  Inventory Tracker
//
//  Created by Ben MacIntyre (School) on 2025-09-22.
//

//
//  PhotoLibraryPicker.swift
//  cameraExample
//
//  Created by Darren Takaki on 2025-07-28.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoLibraryPicker: UIViewControllerRepresentable{
    typealias UIViewControllerType = PHPickerViewController
    @Binding var image: UIImage
    @Environment(\.dismiss) private var dismiss
 
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // 
    }
    
    // MARK: Coordinator
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        var parent: PhotoLibraryPicker
        
        init(parent: PhotoLibraryPicker) {
            self.parent = parent
        }
        
        //required method
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self){
                provider.loadObject(ofClass: UIImage.self) { returnedObject, _ in
                    if let image = returnedObject as? UIImage{
                        self.parent.image = image
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}

