//
//  DeckNotesSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-06.
//  Pourpose:
//      Displays the notes saved in the deck
//  External Types:
//      Deck

import SwiftUI

struct DeckNotesSheet: View {

    // MARK: Stored Properties
    
    var deck: Deck
    
    // MARK: State Properties

    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    @State var notes: String
    
    // MARK: Initializer
    
    init(deck: Deck) {
        self.deck = deck
        self.notes = deck.notes
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
                deck.notes = $notes.wrappedValue
            }
        }
    }
}

