//
//  LegalWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-11.
//  Purpose:
//      A widget display for the legality of a deck

// MARK: Imports

import SwiftUI

// MARK: Types

struct LegalWidget: View {
    
    // MARK: Stored Properties

    var isLegal: Bool
    var ruleType: String
    
    // MARK: View
    
    var body: some View {
        ZStack {
            VStack {
                if isLegal {
                    
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("\(ruleType.capitalized)")
                            .foregroundColor(.gray)
                            .italic()
                    }
                    Text("Legal")
                        .foregroundColor(.white)
                        .bold()
                        .padding(5)
                        .background(.green)
                        .cornerRadius(5)
                } else {
                    HStack {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.red)
                        Text("\(ruleType.capitalized)")
                            .foregroundColor(.gray)
                            .italic()
                    }
                    Text("Not Legal")
                        .foregroundColor(.white)
                        .bold()
                        .padding(5)
                        .background(.red)
                        .cornerRadius(5)
                }
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

