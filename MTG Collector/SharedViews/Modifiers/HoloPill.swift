//
//  HoloPill.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      "Foil" treatment for glass chips: a rarity/finish-coloured gradient read through clear
//      Liquid Glass so it looks like light catching a foil. Two shapes are supported — a capsule
//      (`holoPill`) for small chips and a rounded box (`holoBox`) for the set icon.
//
//      The gradient is a *static* tilted linear band (no rotation/shimmer) so a grid full of pills
//      never runs perpetual GPU animation — that heated the device and led to thermal throttling.
//      The `ShineLevel` still selects whether a chip is plain (`.none`) or foiled, and the caller
//      supplies the per-tier colours; every foiled level renders the same static way.
//

// MARK: Imports

import SwiftUI

// MARK: Shine Level

enum ShineLevel {
    case none
    case linear
    case holo
    case mythic
    /// Violet iridescence tier — special / timeshifted / bonus.
    case special

    /// Violet-dominant palette for the special tier: mostly purple with a white sheen and a single
    /// magenta accent, so it reads as purple (the card's own colour) rather than a full rainbow.
    static let specialPalette: [Color] = [
        Color(red: 0.36, green: 0.12, blue: 0.66),   // deep violet
        Color(red: 0.56, green: 0.26, blue: 0.93),   // purple
        Color(red: 0.80, green: 0.56, blue: 1.00),   // lilac
        .white,                                       // sheen highlight
        Color(red: 0.62, green: 0.30, blue: 0.95),   // purple
        Color(red: 0.88, green: 0.42, blue: 0.92),   // magenta accent
        Color(red: 0.36, green: 0.12, blue: 0.66)    // back to deep violet
    ]
}

// MARK: Modifiers

extension View {
    /// Foil/holographic glass on a capsule (small chips).
    func holoPill(level: ShineLevel, colors: [Color], tint: Color) -> some View {
        modifier(HoloShineModifier(level: level, colors: colors, tint: tint, shape: Capsule()))
    }

    /// Foil/holographic glass on a rounded box (e.g. the set icon).
    func holoBox(level: ShineLevel, colors: [Color], tint: Color, cornerRadius: CGFloat = 10) -> some View {
        modifier(HoloShineModifier(level: level, colors: colors, tint: tint, shape: RoundedRectangle(cornerRadius: cornerRadius)))
    }
}

private struct HoloShineModifier<S: Shape>: ViewModifier {

    let level: ShineLevel
    let colors: [Color]
    let tint: Color
    let shape: S

    func body(content: Content) -> some View {
        if level == .none {
            content.glassEffect(.regular.tint(tint), in: shape)
        } else {
            content.background { foil }
        }
    }

    /// Static tilted linear gradient read through clear glass — same "light catching a foil" look
    /// and the same per-tier colours, but no animation.
    private var foil: some View {
        LinearGradient(
            colors: colors,
            startPoint: UnitPoint(x: 0, y: 0.1),
            endPoint: UnitPoint(x: 1, y: 0.9)
        )
        .opacity(0.55)
        .clipShape(shape)
        .glassEffect(.clear, in: shape)
    }
}
