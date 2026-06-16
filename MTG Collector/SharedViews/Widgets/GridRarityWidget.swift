//
//  GridRarityWidget.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays the rarity based on whats passed to it

// MARK: Imports

import SwiftUI

// MARK: Types

struct GridRarityWidget: View {
    
    // MARK: Stored Properties

    var rarity: String

    // MARK: Computed Properties

    /// Tint colour per rarity tier — used to tint the glass while keeping the colour meaning.
    var tint: Color {
        switch rarity {
        case "common": return .gray
        case "uncommon": return .blue
        case "rare": return .yellow
        case "mythic": return .red
        default: return .gray
        }
    }

    // MARK: View

    var body: some View {
        Text(rarity.capitalized)
            .italic()
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .glassEffect(.regular.tint(tint), in: RoundedRectangle(cornerRadius: 5))
    }
}

