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
            CardImageView(images: card.imageURIs ?? ImageURIsJSON())
            Text(card.name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(10)
    }
}

