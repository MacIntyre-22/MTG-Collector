//
//  InfoLegalWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//  Purpose:
//      Displays all the legalities for a card

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoLegalWidget: View {
    
    // MARK: Stored Properties

    var legalities: [String: String]
    let columns = [
        GridItem(.adaptive(minimum: 200, maximum: 600), spacing: 15),
        GridItem(.adaptive(minimum: 200, maximum: 600), spacing: 15)
    ]
    
    // MARK: View

    var body: some View {
        ZStack {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(legalities.keys.sorted(), id: \.self) { format in
                    if let status = legalities[format] {
                        Text("\(format.capitalized)")
                            .lineLimit(1)
                            .frame(maxWidth: 300)
                            .padding(5)
                            .foregroundColor(.white)
                            .background(color(for: status))
                            .cornerRadius(5)
                    }
                }
            }
            .padding(15)
            .cornerRadius(9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
    
    
    // MARK: color
    
    /// returns a color based on status of legality
    func color(for status: String) -> Color {
        switch status {
        case "legal":
            return .green
        case "not_legal":
            return .red
        case "banned":
            return .red
        case "restricted":
            return .orange
        default:
            return .blue
        }
    }
}


