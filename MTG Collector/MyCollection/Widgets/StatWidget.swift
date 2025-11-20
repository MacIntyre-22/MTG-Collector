//
//  StatWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-11.
//  Purpose:
//      A General stat widget, can be used for any stat where all I needed to pass was a label and a text value (usually a number but can be string)

// MARK: Imports

import SwiftUI

// MARK: Types

struct StatWidget: View {
    
    // MARK: Stored Properties

    var text: String
    var label: Label<Text, Image>
    
    // MARK: View

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
                    .shadow(color: .gray.opacity(0.18), radius: 6, x: 0, y: 0)
            )
        }
    }
}

