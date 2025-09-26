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
                        saveBinder()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    private func saveBinder() {
        let binder = Binder(
            id: UUID(),
            name: name,
            notes: notes,
            createdAt: Date()
        )
        modelContext.insert(binder)
        dismiss()
    }
}
