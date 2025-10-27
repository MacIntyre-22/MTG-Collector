//
//  CardEntryView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct CardEntryView: View {
    var entry: CardEntry
    
    // on delete alert
    @State var alertIsShowing: Bool = false
    
    // Show previews
    var showPreviews: Bool = true
    var showControls: Bool = false
    
    // taking closures allows for functionality with different models like binders and decks
    var deleteEntry: (() -> Void)? = nil
    
    
    
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
                        // remove 1 quantity
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
                    
                    // quantity
                    Text("\(entry.quantity)")
                        .font(.title)
                        .foregroundColor(.primary)
                    
                    Button(action: {
                        // remove 1 quantity
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
                // perform delete
                if let delete = deleteEntry {
                    delete()
                }
            }
        } message: {
            Text("Remove this card from collection?")
        }
        
        
    }
    
    func addCard() {
        // add 1 to quantity
        entry.quantity += 1
    }
    
    func removeCard() {
        if entry.quantity == 1 {
            alertIsShowing.toggle()
        } else {
            entry.quantity -= 1
        }
    }
}
