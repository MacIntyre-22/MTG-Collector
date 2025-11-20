//
//  DeckCardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//  Purpose:
//      Displays cards for a deck view. Using CardEntry it enables controls for the deck the card is in.
//  External Types:
//      Deck, CardEntry, CardInfoView

// MARK: Imports

import SwiftUI

// MARK: Types

struct DeckCardView: View {
    
    // MARK: Stored Properties
    
    var deck: Deck
    var entry: CardEntry
    var deleteEntry: () -> Void
    /// comp the legal status for the card
    var legalStatus: Int {
        var status = 0
        for legality in entry.card.legalities {
            if legality.key == deck.ruleType {
                switch legality.value {
                case "legal":
                    status = 1
                case "not_legal":
                    status = 2
                case "banned":
                    status = 3
                case "restricted":
                    status = 4
                default:
                    status = 0
                }
            }
        }
        return status
    }
    
    // MARK: View
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: CardInfoView(card: entry.card)){
                CardEntryView(
                    entry: entry,
                    showPreviews: deck.showPreviews,
                    showControls: deck.showControls,
                    deleteEntry: {deleteEntry()},
                )
            }
            
            if deck.showControls {
                VStack {
                    Menu {
                        /// Controls
                        Button("Toggle Foil") {
                            entry.isFoil.toggle()
                        }
                        Button("Make Commander") {
                            deck.commander = entry
                        }
                        Button("Mainboard") {
                            mvtoMain(entry: entry)
                        }
                        Button("Sideboard") {
                            mvtoSideboard(entry: entry)
                        }
                        Button("Maybeboard") {
                            mvtoMaybeboard(entry: entry)
                        }
                        Button("Delete", role: .destructive) {
                            deleteEntry()
                        }
                        
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            .bold()
                            .shadow(radius: 4)
                    }
                    .padding(5)
                    
                    /// Show legal status if not legal
                    if legalStatus > 1 {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        /// different status diff colours
                            .foregroundColor(((legalStatus%4) == 0) ? .orange : .red )
                            .bold()
                            .shadow(radius: 4)
                    }
                }
                .padding(.top, 30)
            }
        }
    }
    
    // MARK: Board Moving Functions
    
    func removeAll(entry: CardEntry) {
        deck.mainboard.removeAll { $0.id == entry.id }
        deck.sideboard.removeAll { $0.id == entry.id }
        deck.maybeboard.removeAll { $0.id == entry.id }
    }
    
    func mvtoMain(entry: CardEntry) {
        removeAll(entry: entry)
        deck.mainboard.append(entry)
    }
    
    func mvtoSideboard(entry: CardEntry) {
        removeAll(entry: entry)
        deck.sideboard.append(entry)
    }
    
    func mvtoMaybeboard(entry: CardEntry) {
        removeAll(entry: entry)
        deck.maybeboard.append(entry)
    }
}
