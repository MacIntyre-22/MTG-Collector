//
//  CollectionControllWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-27.
//

import SwiftUI
import SwiftData

struct CollectionControllWidget: View {
    // environment variables
    @Environment(\.modelContext) var modelContext
    // grab all binders
    @Query var binders: [Binder]
    var card: Card
    
    // get selected binder
    @State private var selectedBinder: Binder?
    
    var body: some View {
        HStack() {
            Menu("Add", systemImage: "plus") {
                Text("Binders")
                if !binders.isEmpty {
                    ForEach(binders) { binder in
                        Button(binder.name) {
                            addCard(binder: binder)
                        }
                    }
                } else {
                    Text("No Binders available")
                        .font(.caption)
                }
                
            }
            
            
            Spacer()
        }
    }
    
    // MARK: Add Card
    private func addCard(binder: Binder) {

        // create cardEntry and add to binder
        let entry = CardEntry(card: card)
        binder.cards.append(entry)

    }
}
