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
    @State var selectedBoard: Int = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Button {
                                deck.showPreviews.toggle()
                            } label: {
                                Text("Previews")
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .frame(maxWidth: 100)
                                    .background(deck.showPreviews ? Color.accentColor : Color.gray)
                                    .cornerRadius(5)
                            }
                            
                            Spacer()
                        }
                        
                        if let commander = deck.commander {
                            CommanderWidget(entry: commander) {
                                // remove commander
                                deck.commander = nil
                            }
                        }
                        
                        Picker("Boards", selection: $selectedBoard) {
                            Text("Mainboard").tag(0)
                            Text("Sideboard").tag(1)
                            Text("Maybeboard").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .tint(Color.accentColor)
                    }
                    .padding()
                    
                    switch selectedBoard {
                    case 0: MainboardView(deck: deck)
                    case 1: SideboardView(deck: deck)
                    case 2: MaybeboardView(deck: deck)
                    default: EmptyView()
                    }
                }
            }

        }
        .navigationTitle(deck.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Stats", systemImage: "chart.bar"){
                    showEdit.toggle()
                }
            }
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

