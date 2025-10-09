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
    
    // taking closures allows for functionality with different models like binders and decks
    var deleteEntry: () -> Void
    var contextMenu: (() -> AnyView)? = nil
    
    var body: some View {
        VStack {
            CardGridView(card: entry.card, showPreviews: false)
            HStack {
                Button(action: {
                    // remove 1 quantity
                    removeCard()
                }) {
                    Image(systemName: "minus.circle.fill")
                }
                
                // quantity
                Text("\(entry.quantity)")
                    .foregroundColor(.primary)
                
                Button(action: {
                    // remove 1 quantity
                    addCard()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .padding(10)
            .font(.custom("", size: 30))
        }
        .contextMenu{
            if let menu = contextMenu {
                menu()
            } else {
                EmptyView()
            }
        }
        .background(Color.gray.opacity(0.18))
        .cornerRadius(10)
        .alert("Are you sure?", isPresented: $alertIsShowing) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // perform delete
                deleteEntry()
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
