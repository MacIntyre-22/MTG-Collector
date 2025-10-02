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
    @State private var notes: String = ""
    @State private var coverImage: String = ""

    var body: some View {
        NavigationStack {
            Form {
                // new binder form
                Section("Binder Info") {
                    TextField("Name", text: $name)
                    TextField("Notes", text: $notes)
                    TextField("Cover Image URL", text: $coverImage)
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
        }
    }

    // MARK: saveBinder
    private func saveBinder() {
        // make binder model instance
        let binder = Binder(name: name, notes: notes, coverImage: coverImage)
        // save and dismiss
        modelContext.insert(binder)
        dismiss()
    }
}
