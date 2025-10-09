//
//  DeckView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct DeckView: View {
    @Environment(\.modelContext) var modelContext
    var deck: Deck
    
    @State var showEdit: Bool = false
    @State var showNotes: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: Mainboard
                Section("Mainboard") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(deck.mainboard) { entry in
                                NavigationLink(destination: CardInfoView(card: entry.card)){
                                    CardEntryView(
                                        entry: entry,
                                        deleteEntry: {deck.mainboard.removeAll { $0.id == entry.id }},
//                                        contextMenu: {
//                                            ContextMenu(menuItems: {
//                                                Button("Delete") {
//                                                    
//                                                }
//                                            })
//                                        }
                                    )
                                    .frame(width: 150)
                                }
                            }
                        }
                    }
                }
                
                // MARK: Sideboard
                Section("Sideboard") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(deck.sideboard) { entry in
                                CardEntryView(
                                    entry: entry,
                                    deleteEntry: {deck.sideboard.removeAll { $0.id == entry.id }}
                                )
                                .frame(width: 150)
                            }
                        }
                    }
                }
                
                // MARK: Maybeboard
                Section("Maybeboard") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(deck.maybeboard) { entry in
                                CardEntryView(
                                    entry: entry,
                                    deleteEntry: {deck.maybeboard.removeAll { $0.id == entry.id }}
                                )
                                .frame(width: 150)
                            }
                        }
                    }
                }
            }

        }
        .navigationTitle(deck.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Notes", systemImage: "note.text"){
                    showNotes.toggle()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "square.and.pencil"){
                    showEdit.toggle()
                }
            }
        })
        .sheet(isPresented: $showEdit) {
            EditDeckSheet(deck: deck)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showNotes) {
            DeckNotesSheet(deck: deck)
                .presentationDetents([.medium, .large])
        }
    }
}

