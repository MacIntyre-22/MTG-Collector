//
//  DeckView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
// Purpose:
//     Used to display all binder information and cards
// External Types:
//      Deck, ImageManager, HeaderWidget, CommanderWidget, MainboardView, SideboardView, MaybeboardView, DeckStatSheet, EditDeckSheet, DeckNotesSheet

// MARK: Imports

import SwiftUI

// MARK: Types

struct DeckView: View {
    
    // MARK: Stored Properties
    
    var deck: Deck
    var coverImage: UIImage
    
    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @State var showEdit: Bool = false
    @State var showNotes: Bool = false
    @State var showStats: Bool = false
    @State var selectedBoard: Int = 0
    
    // MARK: Initializer
    
    init(deck: Deck) {
        self.deck = deck
        self.coverImage = ImageManager.fetchImage(withIdentifier: deck.id) ?? UIImage(named: "MtgDeck")!
    }
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    HeaderWidget(showCover: deck.showCover, coverImage: coverImage, name: deck.name, price: deck.totalPrice, count: deck.cardCount)
                    
                    if let commander = deck.commander {
                        CommanderWidget(entry: commander) {
                            // remove commander
                            deck.commander = nil
                        }
                        .padding()
                    }
                    switch selectedBoard {
                    case 0: MainboardView(deck: deck)
                    case 1: SideboardView(deck: deck)
                    case 2: MaybeboardView(deck: deck)
                    default: EmptyView()
                    }
                }
            }
        }
        .toolbar(content: {
            
            ToolbarItem(placement: .topBarTrailing) {
                // picker for card view
                Picker("Boards", selection: $selectedBoard) {
                    Text("Main").tag(0)
                    Text("Side").tag(1)
                    Text("Maybe").tag(2)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu{
                    Button("Stats", systemImage: "chart.bar"){
                        showStats.toggle()
                    }
                    Button("Notes", systemImage: "note.text"){
                        showNotes.toggle()
                    }
                    Button("Settings", systemImage: "gearshape"){
                        showEdit.toggle()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        })
        .sheet(isPresented: $showStats) {
            DeckStatsSheet(deck: deck)
        }
        .sheet(isPresented: $showEdit) {
            EditDeckSheet(deck: deck)
        }
        .sheet(isPresented: $showNotes) {
            DeckNotesSheet(deck: deck)
                .presentationDetents([.medium, .large])
        }
    }
    
}

