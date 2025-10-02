//
//  NewDeckSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-26.
//

import SwiftUI

struct NewDeckSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    // data

    // user input for new deck
    @State var name: String = ""
    @State var notes: String = ""
    @State var coverImage: String = ""
    // default to casual, no legalities
    @State var ruleType: String = "casual"
    
    // list of Scryfall legality types
    let legalities = [
        "standard",
        "modern",
        "legacy",
        "vintage",
        "pauper",
        "commander",
        "oathbreaker",
        "historic",
        "alchemy",
        "pioneer",
        "explorer",
        "brawl",
        "future",
        "oldschool",
        "premodern",
        "penny",
        "casual"
    ]

    var body: some View {
        NavigationStack {
            Form {
                // deck form
                Section("Deck Info") {
                    TextField("Name", text: $name)
                    TextField("Notes", text: $notes)
                    TextField("Cover Image URL", text: $coverImage)
                    
                    // select rule type from array of legalities
                    Picker("Rule Type", selection: $ruleType) {
                        ForEach(legalities, id: \.self) { legality in
                            // capitalize for display
                            Text(legality.capitalized)
                                .tag(legality)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                
                }
            }
            .navigationTitle("New Deck")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        // save deck
                        saveDeck()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }

    // MARK: saveDeck
    private func saveDeck() {
        // make a deck model instance
        let deck = Deck(name: name, notes: notes, ruleType: ruleType)
        // save and dismiss
        modelContext.insert(deck)
        dismiss()
    }
}

