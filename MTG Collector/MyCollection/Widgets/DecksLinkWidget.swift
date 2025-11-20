//
//  AllDecksLinkWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//      A Unique widget to link to the decks grid from the collection view

// MARK: Imports

import SwiftUI

// MARK: Types

struct AllDecksLinkWidget: View {
    
    // MARK: View

    var body: some View {
        ZStack {
            HStack {
                Image("MtgDeck")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .foregroundColor(.primary)
                    .padding(10)
                Text("Decks")
                    .foregroundColor(.primary)
                    .bold()
                    .font(.title2)
                Image(systemName: "chevron.right")
                    .foregroundColor(.primary)
                    .bold()
                Spacer()
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
}

