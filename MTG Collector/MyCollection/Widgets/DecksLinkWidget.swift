//
//  AllDecksLinkWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct AllDecksLinkWidget: View {
    var body: some View {
        HStack {
            Image("MtgDeck")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 75, height: 75)
                .foregroundColor(.primary)
                .padding(10)
            VStack(alignment: .leading) {
                Text("My Decks")
            }
            .padding(10)
        }
    }
}

