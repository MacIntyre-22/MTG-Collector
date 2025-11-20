//
//  BinderCardView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//  Purpose:
//      The view used to display cards in the binder view. Using the CardEntryView, it gives the user control over the card
//  External Types:
//      CardEntry, CardInfoView

// MARK: Imports

import SwiftUI

// MARK: Types

struct BinderCardView: View {
    
    // MARK: Stored Properties
    
    var entry: CardEntry
    var deleteEntry: () -> Void
    var showPreviews: Bool
    var showControls: Bool
    
    // MARK: View
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigationLink(destination: CardInfoView(card: entry.card)){
                CardEntryView(
                    entry: entry,
                    showPreviews: showPreviews,
                    showControls: showControls,
                    deleteEntry: {deleteEntry()},
                )
            }
            
            if showControls {
                VStack {
                    Menu {
                        Button("Toggle Foil") {
                            entry.isFoil.toggle()
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
                }
                .padding(.top, 30)
            }
        }
    }
}

