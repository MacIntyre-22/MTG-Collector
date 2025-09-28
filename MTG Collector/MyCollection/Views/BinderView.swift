//
//  BinderView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct BinderView: View {
    var binder: Binder
    
    var body: some View {
        ScrollView {
            Section("Cards") {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(binder.cards) { entry in
                            VStack {
                                CardImageView(imageUrl: entry.card.imageURIs?.normal ?? "https://c1.scryfall.com/file/scryfall-cards/back/neo/442.jpg")
                                Text(entry.card.name)
                                Divider()
                                
                                Text(entry.card.colors?.first ?? "No Color")

                            
                            }
                        }
                    }
                    
                }
            }
        }
        Spacer()
    }
}

