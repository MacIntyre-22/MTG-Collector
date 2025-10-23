//
//  CameraPicker.swift
//  Inventory Tracker
//
//  Created by Ben MacIntyre (School) on 2025-09-22.
//

import Foundation
import PhotosUI
import SwiftUI

struct CameraPicker:UIViewControllerRepresentable{
    typealias UIViewControllerType = UIImagePickerController
    @Binding var image: UIImage
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //
    }
    
    
    // MARK: Coordinator
    class Coordinator:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
        var parent: CameraPicker
        
        init(parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
                parent.image = image
            }
            
            parent.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
}
