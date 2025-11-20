//
//  CommanderWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-09.
//  Purpose:
//      Used to display a decks commander card if it has one
//  External Types:
//      CardEntry

// MARK: Imports

import SwiftUI

// MARK: Types

struct CommanderWidget: View {
    
    // MARK: Stored Properties
    
    var entry: CardEntry
    var remove: () -> Void
    
    // MARK: View
    
    var body: some View {
        NavigationLink(destination: CardInfoView(card: entry.card)) {
            HStack {
                CardImageView(maxWidth: 85, name: entry.card.name, imageURIs: entry.card.imageURIs)
                
                VStack(alignment: .leading) {
                    Text("Commander")
                        .bold()
                    Text(entry.card.name)
                    HStack {
                        // Multi-face card
                        ForEach(entry.card.colors, id: \.self) { color in
                            Image(color)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Spacer()
                    }
                    
                    Menu {
                        Button("Remove") {
                            remove()
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
                    Spacer()
                }
                .foregroundColor(.primary)
                .padding(.vertical, 5)
            }
            .padding(10)
            .background(Color.gray.opacity(0.18))
            .cornerRadius(10)
            .frame(maxWidth: 600)
        }
    }
}

