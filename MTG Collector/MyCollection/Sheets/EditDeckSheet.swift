//
//  EditDeckSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-06.
//

import SwiftUI

struct EditDeckSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    
    var deck: Deck
    
    @State var name: String
    //@State var coverImage: String
    @State var ruleType: String
    
    init(deck: Deck) {
        self.deck = deck
        self.name = deck.name
        self.ruleType = deck.ruleType
    }
    
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
                // edit deck
                // deck form
                Section("Deck Info") {
                    TextField("Name", text: $name)
                    
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
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save"){
                        dismiss()
                    }
                }
            })
            .navigationTitle("Edit Deck")
            .onDisappear() {
                deck.name = $name.wrappedValue
                deck.ruleType = $ruleType.wrappedValue
            }
        }
    }
}

