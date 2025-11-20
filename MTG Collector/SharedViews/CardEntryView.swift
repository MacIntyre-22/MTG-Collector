//
//  CardEntryView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//  Purpose:
//      Displays a card entry with some preview information and controls
//  External Types:
//      CardEntry, CardGridView

// MARK: Imports

import SwiftUI

// MARK: Types

struct CardEntryView: View {
    
    // MARK: Stored Properties

    var entry: CardEntry
    var showPreviews: Bool = true
    var showControls: Bool = false
    
    // MARK: State Properties

    @State var alertIsShowing: Bool = false
    
    /// taking closures allows for functionality with different models like binders and decks
    var deleteEntry: (() -> Void)? = nil
    
    // MARK: View
    
    var body: some View {
        VStack {
            
            ZStack(alignment: .topLeading) {
                CardGridView(card: entry.card, showPreviews: showPreviews, isFoil: entry.isFoil)
                if !showControls {
                    VStack {
                        Text("x\(entry.quantity)")
                            .foregroundColor(.white)
                            .bold()
                            .shadow(radius: 4)
                            .font(.headline)
                            .padding(5)
                        
                        
                    }
                    .padding(.top, 30)
                }
            }
            
            
            if showControls {
                HStack {
                    Button(action: {
                        removeCard()
                    }) {
                        Image(systemName: "minus")
                            .frame(width: 20, height: 20)
                        
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            .bold()
                    }
                    .padding(.trailing, 10)
                    Text("\(entry.quantity)")
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        addCard()
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding(5)
                            .background(Color.accentColor)
                            .cornerRadius(5)
                            .bold()
                    }
                    .padding(.leading, 10)
                }
                .padding(10)
            }
        }
        .background(Color.gray.opacity(0.18))
        .cornerRadius(10)
        .alert("Are you sure?", isPresented: $alertIsShowing) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let delete = deleteEntry {
                    delete()
                }
            }
        } message: {
            Text("Remove this card from collection?")
        }
    }
    
    // MARK: Card Controls
    
    /// add a quantity to cardentry
    func addCard() {
        entry.quantity += 1
    }
    
    /// remove 1 from quantity or toggle alert to delete the entry from the collection
    func removeCard() {
        if entry.quantity == 1 {
            alertIsShowing.toggle()
        } else {
            entry.quantity -= 1
        }
    }
}
