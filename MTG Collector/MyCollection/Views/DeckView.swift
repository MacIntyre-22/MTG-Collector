//
//  DeckView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct DeckView: View {
    var deck: Deck
    @State var showBuildSheet: Bool = false
    
    var body: some View {
        List {
            // MARK: Deck Stats
            Section("Statistics") {
                DeckStatsWidget(deck: deck)
            }
            
            // MARK: Mainboard
            Section("Mainboard") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(deck.mainboard) { entry in
                            CardEntryView(entry: entry, deleteEntry: {})
                                .frame(width: 150)
                        }
                    }
                }
            }
            
            // MARK: Sideboard
            Section("Sideboard") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(deck.sideboard) { entry in
                            CardEntryView(entry: entry, deleteEntry: {})
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
                            CardEntryView(entry: entry, deleteEntry: {})
                                .frame(width: 150)
                        }
                    }
                }
            }

        }
        .navigationTitle(deck.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Build", systemImage: "plus"){
                    showBuildSheet.toggle()
                }
            }
        })
        .sheet(isPresented: $showBuildSheet) {
            DeckBuildSheet(deck: deck)
        }
        Spacer()
    }
}

