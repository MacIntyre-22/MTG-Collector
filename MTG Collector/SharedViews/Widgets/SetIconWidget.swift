//
//  SetIconWidget.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-10-03.
//  Purpose:
//      Displays a set icon and with the rarity as the background

// MARK: Imports

import SwiftUI

// MARK: Types

struct SetIconWidget: View {
    
    // MARK: Stored Properties

    var set: String
    var rarity: String
    var maxWidth: Double
    var img: String {
        if !set.isEmpty {
            return set
        } else {
            return "MtgBinder"
        }
    }
    /// Tint colour per rarity tier — tints the glass background while keeping the meaning.
    var tint: Color {
        switch rarity {
        case "common": return .gray
        case "uncommon": return .blue
        case "rare": return .yellow
        case "mythic": return .red
        default: return .gray
        }
    }

    /// Only rare/mythic get the foil treatment.
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
        ZStack {
            /// check if asset exists
            /// i dont have every set logo
            if UIImage(named: img) != nil {
                Image(img)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(5)
                    .shadow(radius: 4)
            } else {
                /// default is just planeswalker logo
                Image("Logo")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(5)
                    .shadow(radius: 4)
            }
        }
        .frame(width: maxWidth, height: maxWidth)
        .holoBox(level: shine, colors: holoColors, tint: tint)
        .foregroundColor(.primary)
    }
}
