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
        VStack(alignment: .leading) {
            // Typeline
            if let typeLine = card.typeLine {
                Text(typeLine)
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
                Spacer()
            }
            .padding(.vertical, 10)
            
            if let text = card.oracleText {
                Text("\" \(text) \"")
                    .font(.custom("ManaMTG", size: 18))
                    .italic()
                    .lineSpacing(1.3)
            }
            
            
        }
        
            
    }
}

