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
                
            }
            
            // MARK: Mainboard
            Section("Mainboard") {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(deck.mainboard) { entry in
                            CardBoardView(entry: entry)
                        }
                    }
                }
            }
            
            // MARK: Sideboard
            Section("Sideboard") {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(deck.sideboard) { entry in
                            CardBoardView(entry: entry)
                        }
                    }
                }
            }
            
            // MARK: Maybeboard
            Section("Maybeboard") {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(deck.maybeboard) { entry in
                            CardBoardView(entry: entry)
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

