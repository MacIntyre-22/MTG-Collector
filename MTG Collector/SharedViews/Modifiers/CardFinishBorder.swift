//
//  CardFinishBorder.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The finish treatment for a card image: instead of washing the whole card in colour, a
//      foil/etched card gets an iridescent *border* (foil = rainbow, etched = silver/chrome — the
//      same finish language as the price pills). It's a static gradient ring, no animation, so a
//      grid full of foil cards doesn't run perpetual GPU work. Nonfoil renders nothing. Applied via
//      the `cardFinish(_:)` modifier.
//  External Types:
//      CardFinish
//

// MARK: Imports

import SwiftUI

// MARK: Modifier

extension View {
    /// Overlay a card image with its finish border. The ring floats a little *outside* the card
    /// (a `gap` of clear space between the card edge and the border) and is drawn thin so it frames
    /// the card rather than sitting on it. Nonfoil is a no-op.
    @ViewBuilder
    func cardFinish(_ finish: CardFinish, cornerRadius: CGFloat = 8, lineWidth: CGFloat = 3, gap: CGFloat = 5) -> some View {
        switch finish {
        case .nonfoil:
            self
        case .foil, .etched:
            overlay(
                CardFinishBorder(finish: finish, cornerRadius: cornerRadius + gap, lineWidth: lineWidth)
                    .padding(-gap)   // push the ring outward, into the margin around the card
            )
        }
    }
}

// MARK: Border

struct CardFinishBorder: View {

    let finish: CardFinish
    var cornerRadius: CGFloat = 8
    var lineWidth: CGFloat = 3

    /// Same palettes as the finish price pills (foil = rainbow, etched = silver/chrome), wrapped so
    /// the gradient meets cleanly at the corners.
    private var colors: [Color] {
        switch finish {
        case .foil:   return [.pink, .red, .orange, .yellow, .pink]
        case .etched: return [.gray, .white, Color(white: 0.25), .gray, .white, .gray]
        case .nonfoil: return []
        }
    }

    var body: some View {
        // Static iridescent ring, tilted to match the finish pills' gradient direction, kept
        // translucent so it reads as a subtle sheen rather than popping.
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .strokeBorder(
                LinearGradient(colors: colors,
                               startPoint: UnitPoint(x: 0, y: 0.1),
                               endPoint: UnitPoint(x: 1, y: 0.9)),
                lineWidth: lineWidth
            )
            .opacity(0.55)
            .allowsHitTesting(false)
    }
}
