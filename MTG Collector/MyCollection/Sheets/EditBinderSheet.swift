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
    @Environment(\.modelContext) var modelContext
    
    var binder: Binder
    
    @State var name: String
    @State var coverImage: String
    
    init(binder: Binder) {
        self.binder = binder
        self.name = binder.name
        self.coverImage = binder.coverImage
    }

    var body: some View {
        NavigationStack {
            Form {
                // new binder form
                Section("Binder Info") {
                    TextField("Name", text: $name)
                    TextField("Cover Image URL", text: $coverImage)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save"){
                        dismiss()
                    }
                }
            })
            .navigationTitle("New Binder")
            .onDisappear() {
                // set binder values
                binder.name = $name.wrappedValue
                binder.coverImage = $coverImage.wrappedValue
            }
        }
    }
}

