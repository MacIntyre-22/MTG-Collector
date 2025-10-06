//
//  DeckNotesSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-06.
//

import SwiftUI

struct DeckNotesSheet: View {
    // environment variables
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var deck: Deck
    
    @State var notes: String
    
    init(deck: Deck) {
        self.deck = deck
        self.notes = deck.notes
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
            }
            .padding()
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save"){
                        dismiss()
                    }
                }
            })
            .onDisappear() {
                // set notes 
                deck.notes = $notes.wrappedValue
            }
        }
    }
}

