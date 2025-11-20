//
//  InfoDisplayWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//  Purpose:
//      Displays basic info passed to it

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoDisplayWidget: View {
    
    // MARK: Stored Properties

    var name: String?
    var typeLine: String?
    var colorIdentity: [String]?
    var oracleText: String?
    
    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            if let name = name {
                Text(name)
                    .bold()
            }
            if let typeLine = typeLine {
                Text(typeLine)
                    .italic()
            }
            if let colors = colorIdentity {
                HStack {
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
                    .padding(.bottom, 10)
            }
            
            
        }
        
            
    }
}

