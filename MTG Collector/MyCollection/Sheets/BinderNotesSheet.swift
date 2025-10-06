//
//  BinderNotesSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-06.
//

import SwiftUI

struct BinderNotesSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var binder: Binder
    
    @State var notes: String
    
    init(binder: Binder) {
        self.binder = binder
        self.notes = binder.notes
    }

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
                // set notes
                binder.notes = $notes.wrappedValue
            }
        }
    }
}

