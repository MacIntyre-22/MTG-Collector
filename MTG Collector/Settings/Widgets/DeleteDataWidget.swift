//
//  DeleteDataWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//

import SwiftUI
import SwiftData

struct DeleteDataWidget: View {
    @Environment(\.modelContext) var modelContext
    
    // get whole collection
    @Query var binders: [Binder]
    @Query var decks: [Deck]
    @Query var settings: [Settings]
    
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            Button(role: .destructive) {
                showAlert.toggle()
            } label: {
                Text("Delete Data")
                    .foregroundColor(.white)
                    .bold()
                    .padding(10)
                    .frame(maxWidth: 600)
                    .frame(minHeight: 45)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.red)
                    .shadow(color: .gray.opacity(0.25), radius: 15, x: 0, y: 0)
            )
        }
        .alert("Continue?", isPresented: $showAlert) {
            Button(role: .cancel) {
                
            } label: {
                Text("Cancel")
            }
            
            Button(role: .destructive) {
                // delete all data
                for binder in binders {
                    modelContext.delete(binder)
                }
                for deck in decks {
                    modelContext.delete(deck)
                }
                for setting in settings {
                    modelContext.delete(setting)
                }
                
            } label: {
                 Text("Delete")
            }
            
        } message: {
            Text("This will erase your collection")
        }
    }
}

