//
//  ImageManager.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-22.
//  Purpose:
//         Manages adding images from user library and camera

// MARK: Imports

import UIKit

// MARK: Types

class ImageManager {
    
    // MARK: Stored Properties
    
    static var documentDirectory: URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    // MARK: Image Functions
    
    /// save image using id
    static func saveImage(forImage image: UIImage, withIdentifier id: String){
        if var imagePath = documentDirectory?.appendingPathComponent(id){
            imagePath = imagePath.appendingPathExtension("png")
            if let data = image.jpegData(compressionQuality: 0.8){
                do {
                    try data.write(to: imagePath)
                } catch {
                    print("Error saving image - \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// get image by id
    static func fetchImage(withIdentifier id: String) -> UIImage?{
        if let imagePath = documentDirectory?.appendingPathComponent(id).appendingPathExtension("png"), let imageFromDisk = UIImage(contentsOfFile: imagePath.path){
            return imageFromDisk
        }
        return nil
    }
}
