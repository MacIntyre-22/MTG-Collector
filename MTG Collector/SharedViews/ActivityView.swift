//
//  ActivityView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Thin SwiftUI wrapper over UIActivityViewController (the iOS share sheet). Used to share a
//      Universal Link to a collection, or an exported .txt / .csv file.
//  External Types:
//      (UIKit)
//

// MARK: Imports

import SwiftUI
import UIKit

// MARK: Types

struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
