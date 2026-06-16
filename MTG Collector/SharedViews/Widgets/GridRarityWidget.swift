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

    /// Only rare/mythic get the foil treatment, so they pop against the calmer lower tiers.
    var shine: ShineLevel {
        switch rarity {
        case "rare": return .holo
        case "mythic": return .mythic
        default: return .none
        }
    }

    /// Holo gradient colours per tier (rare = gold, mythic = fiery).
    var holoColors: [Color] {
        switch rarity {
        case "rare": return [.yellow, .orange, .white, .yellow, .orange]
        case "mythic": return [.red, .orange, .yellow, .pink, .red]
        default: return [tint]
        }
    }

    // MARK: View

    var body: some View {
        Text(rarity.capitalized)
            .italic()
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .holoPill(level: shine, colors: holoColors, tint: tint)
    }
}

