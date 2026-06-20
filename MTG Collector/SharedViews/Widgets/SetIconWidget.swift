//
//  SetIconWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-03.
//  Purpose:
//      Displays a set symbol with a rarity-tinted holographic box behind it. The icon is loaded
//      from Scryfall's SVG via SetIconCache (rendered white on transparent, cached in NSCache).
//      While loading, or if no URI is registered for the set, a bundled fallback is shown.
//  External Types:
//      SetIconCache, SetIconRegistry
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct SetIconWidget: View {

    // MARK: Stored Properties

    var set: String
    var rarity: String
    var maxWidth: Double

    // MARK: State Properties

    @State private var icon: UIImage?

    // MARK: Derived

    var tint: Color {
        switch rarity {
        case "common":   return .gray
        case "uncommon": return .blue
        case "rare":     return .yellow
        case "mythic":   return .red
        case "special", "timeshifted", "bonus": return .purple
        default:         return .gray
        }
    }

    var shine: ShineLevel {
        switch rarity {
        case "rare":                            return .holo
        case "mythic":                          return .mythic
        case "special", "timeshifted", "bonus": return .special
        default:                                return .none
        }
    }

    var holoColors: [Color] {
        switch rarity {
        case "rare":   return [.yellow, .orange, .white, .yellow, .orange]
        case "mythic": return [.red, .orange, .yellow, .pink, .red]
        case "special", "timeshifted", "bonus": return ShineLevel.specialPalette
        default:       return [tint]
        }
    }

    // MARK: View

    var body: some View {
        ZStack {
            if let icon {
                Image(uiImage: icon)
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .shadow(radius: 4)
            } else {
                fallbackIcon
            }
        }
        .frame(width: maxWidth, height: maxWidth)
        .holoBox(level: shine, colors: holoColors, tint: tint)
        .foregroundColor(.primary)
        .task(id: set) {
            // Instant hit from NSCache — no flicker on revisit
            if let cached = SetIconCache.shared.image(for: set) {
                icon = cached
                return
            }
            guard let uri = SetIconRegistry.shared.iconURI(for: set) else { return }
            icon = await SetIconCache.shared.load(code: set, uri: uri)
        }
    }

    // MARK: Fallback

    /// SF Symbol placeholder shown while the SVG renders or if no URI is registered.
    private var fallbackIcon: some View {
        Image(systemName: "seal.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white.opacity(0.6))
            .padding(10)
            .shadow(radius: 4)
    }
}
