//
//  CardFinishBorder.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The finish treatment for a card image: instead of washing the whole card in colour, a
//      foil/etched card gets an iridescent *border* with a sweeping sheen — the same finish language
//      as the price pills (foil = rainbow, etched = silver/chrome from GridPriceWidget). Nonfoil
//      renders nothing. Applied via the `cardFinish(_:)` modifier.
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

    @State private var shimmer = -1.0

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
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        ZStack {
            // Iridescent gradient ring — tilted to match the price pill's gradient direction, and
            // kept translucent (like the pills) so it reads as a subtle sheen rather than popping.
            shape
                .strokeBorder(
                    LinearGradient(colors: colors,
                                   startPoint: UnitPoint(x: 0, y: 0.1),
                                   endPoint: UnitPoint(x: 1, y: 0.9)),
                    lineWidth: lineWidth
                )
                .opacity(0.55)

            // Sweeping white sheen, masked to the ring so only the border catches the light. The
            // band is taller than the card so it covers the top and bottom edges through the whole
            // sweep, and the mask uses `strokeBorder` (inset) to match the visible ring exactly, so
            // the sheen can't spill outside the card.
            GeometryReader { geo in
                Rectangle()
                    .fill(LinearGradient(colors: [.clear, .white.opacity(0.4), .clear],
                                         startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * 0.4, height: geo.size.height * 2.4)
                    .rotationEffect(.degrees(22))
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .offset(x: shimmer * geo.size.width * 1.2)
            }
            .mask(shape.strokeBorder(lineWidth: lineWidth))
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: false).delay(0.3)) {
                shimmer = 1.0
            }
        }
    }
}
