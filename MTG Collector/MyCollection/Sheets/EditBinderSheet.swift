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
    
    var binder: Binder

    // user input for new binder
    @State private var name: String
    @State private var coverImage: String
    
    init(binder: Binder) {
        self.binder = binder
        self.name = binder.name
        self.coverImage = binder.coverImage
    }

    var body: some View {
        NavigationStack {
            Form {
                // edit binder
                Section("Binder info") {
                    TextField("Name", text: $name)
                    TextField("Cover Image URL", text: $coverImage)
                }
            }
            .navigationTitle("Edit Binder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // save binder
                        saveBinder()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    // MARK: saveBinder
    private func saveBinder() {
        // set new values
        binder.name = name
        binder.coverImage = coverImage
        
        // dismiss
        dismiss()
    }
}

