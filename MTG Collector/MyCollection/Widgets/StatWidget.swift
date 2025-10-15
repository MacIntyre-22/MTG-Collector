//
//  StatWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-11.
//

import SwiftUI

struct StatWidget: View {
    
    var text: String
    var label: Label<Text, Image>
    
    var body: some View {
        ZStack {
            VStack {
                label
                    .foregroundColor(.gray)
                    .italic()
                Text(text)
                    .lineLimit(1)
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: 270, maxHeight: 100)
            .aspectRatio(1, contentMode: .fill)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.18), radius: 15, x: 0, y: 0)
            )
        }
    }
}

