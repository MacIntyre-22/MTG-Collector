//
//  CardGridView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct CardGridView: View {
    var card: CardJSON
    
    var body: some View {
        VStack{
            CardImageView(imageUrl: card.imageURIs?.normal ?? "https://c1.scryfall.com/file/scryfall-cards/back/neo/442.jpg")
            Text(card.name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(10)
    }
}

