//
//  InfoDisplayWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct InfoDisplayWidget: View {
    var name: String?
    var typeLine: String?
    var colorIdentity: [String]?
    var oracleText: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            // name
            if let name = name {
                Text(name)
                    .bold()
            }
            
            // Typeline
            if let typeLine = typeLine {
                Text(typeLine)
                    .italic()
            }
            
            // Colours
            if let colors = colorIdentity {
                HStack {
                
                    // Multi-face card
                    ForEach(colors, id: \.self) { color in
                        Image(color)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }
            
            
            if let text = oracleText {
                Text("\"\(text)\"")
                    .font(.custom("ManaMTG", size: 18))
                    .italic()
                    .lineSpacing(1.3)
            }
            
            
        }
        
            
    }
}

