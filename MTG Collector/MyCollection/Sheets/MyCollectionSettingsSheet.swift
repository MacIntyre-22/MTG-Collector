//
//  MyCollectionSettingsSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Settings for the permanent "My Hold" catch-all binder. Mirrors the binder controls
//      (minus the cover image, since the catch-all has no cover). This is the home for any
//      future My-Collection-specific settings — add new Sections here.
//  External Types:
//      Binder
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct MyCollectionSettingsSheet: View {

    // MARK: Stored Properties

    var collection: Binder

    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @State private var showPreviews: Bool
    @State private var showControls: Bool

    // MARK: Initializer

    init(collection: Binder) {
        self.collection = collection
        self.showPreviews = collection.showPreviews
        self.showControls = collection.showControls
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Toggle("Previews", isOn: $showPreviews)
                    Toggle("Controls", isOn: $showControls)
                }

                // Future My Hold settings go here as additional Sections.
            }
            .navigationTitle("My Hold Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { dismiss() }
                }
            }
            .onDisappear {
                collection.showPreviews = showPreviews
                collection.showControls = showControls
            }
        }
    }
}
