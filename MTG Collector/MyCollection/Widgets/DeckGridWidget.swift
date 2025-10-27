//
//  DeckGridWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-26.
//

import SwiftUI

struct DeckGridWidget: View {
    var deck: Deck
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack(alignment: .topLeading) {
                Color.gray
                    .frame(maxWidth: 200, maxHeight: 200)
                    .cornerRadius(10)
                if let image =  ImageManager.fetchImage(withIdentifier: deck.id){
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(maxWidth: 200)
                        .cornerRadius(10)
                } else {
                    
                    Image("MtgDeck")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(maxWidth: 200)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading) {
                    Button {
                        // set pinned
                        deck.pinned.toggle()
                    } label: {
                        Image(systemName: deck.pinned ? "pin.fill"
                              : "pin")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .shadow(radius: 4)
                            .foregroundColor(Color.accentColor)
                    }
                    
                    Spacer()
                    
                    HStack {
                        // Multi-face card
                        if let commander = deck.commander {
                            ForEach(commander.card.colors, id: \.self) { color in
                                Image(color)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .shadow(radius: 4)
                            }
                        }
                    }
                }
                .padding(5)
            }
            
            VStack {
                
                Text(deck.name)
                    .bold()
                
                HStack {
                    Text(deck.totalPrice, format: .currency(code: "CAD"))
                        .padding(5)
                        .foregroundColor(.green)
                        .background(Color.green.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .lineLimit(1)
                    
                    Image(systemName: "square.stack")
                        .foregroundColor(.primary)
                    
                    Text("\(deck.cardCount)")
                }
            }
        }
        .foregroundColor(.primary)
        .padding(10)
        .background(Color.gray.opacity(0.18))
        .cornerRadius(10)
        
    }
}

