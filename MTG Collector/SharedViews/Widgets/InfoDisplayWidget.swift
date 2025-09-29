//
//  InfoDisplayWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct InfoDisplayWidget: View {
    var card: CardJSON
    
    var body: some View {
        VStack {
            VStack {
                // Typeline
                if let typeLine = card.typeLine {
                    Text(typeLine)
                        .font(.custom("ManaMTG", size: 20))
                        .bold()
                }
                
                // Colours
                HStack {
                    if let colors = card.colorIdentity {
                        // Multi-face card
                        ForEach(colors, id: \.self) { color in
                            Image(color)
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
            }
            
            
            
            // color identity to show all mana colors it may use
            
            // text
            
        }
    }
}

