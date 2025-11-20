//
//  BinderNotesSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-06.
//  Purpose:
//      Displays the notes that belong to the binder
//  External Types:
//      Binder

// MARK: Imports

import SwiftUI

struct BinderNotesSheet: View {

    // MARK: Stored Properties
    
    var binder: Binder

    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var notes: String
    
    // MARK: Initializer
    
    init(binder: Binder) {
        self.binder = binder
        self.notes = binder.notes
    }
    
    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Notes")
                        .font(.title)
                        .bold()
                    TextEditor(text: $notes)
                        .frame(height: 400)
                }
                .padding()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save"){
                        dismiss()
                    }
                }
            })
            .onDisappear() {
                binder.notes = $notes.wrappedValue
            }
        }
    }
}

