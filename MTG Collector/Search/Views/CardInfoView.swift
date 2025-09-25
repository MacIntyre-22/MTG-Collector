//
//  CardInfoView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardInfoView: View {
    var card: CardJSON
    
    var body: some View {
        ScrollView {
            CardImageView(imageUrl: card.imageURIs?.normal ?? "https://c1.scryfall.com/file/scryfall-cards/back/neo/442.jpg")
            Text(card.name)
            Text(card.flavorText ?? "")
        }
    }
}

