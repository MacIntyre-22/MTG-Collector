//
//  ManaCountWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-11.
//  Purpose:
//      Displays the mana count of a collection in a widget style

// MARK: Imports

import SwiftUI

// MARK: Types

struct ManaCountWidget: View {
    
    // MARK: Stored Properties

    var manaTypeCount: [String: Int]
    
    // MARK: View
    
    var body: some View {
        ZStack {
            VStack {
                Text("Mana Counts")
                    .font(.title3)
                    .bold()
                Label("Total not equal to Cards", systemImage: "info.circle")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.bottom, 15)
                HStack(spacing: 20) {
                    Spacer()
                    ForEach(Array(manaTypeCount), id: \.key) { color, value in
                        VStack {
                            Image(color)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text("\(value)")
                                .bold()
                        }
                    }
                    Spacer()
                }
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.18), radius: 6, x: 0, y: 0)
            )
        }
    }
}

