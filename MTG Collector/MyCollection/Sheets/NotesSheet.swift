//
//  NotesSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-03.
//

import SwiftUI

struct NotesSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    
    var binder: Binder

    // notes binding
    @State private var notes: String
    
    init(binder: Binder) {
        self.binder = binder
        self.notes = binder.notes
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                TextEditor(text: $notes)
                    .padding()
                    .frame(height: 300)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // save binder
                        saveNotes()
                    }
                }
            }
        }
    }

    // MARK: saveNotes
    private func saveNotes() {
        // set new values
        binder.notes = notes
        
        // dismiss
        dismiss()
    }
}

