//
//  HoloPill.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      "Foil" treatment for glass chips: a rarity/finish-coloured gradient read through clear
//      Liquid Glass so it looks like light catching a foil. Two shapes are supported — a capsule
//      (`holoPill`) for small chips and a rounded box (`holoBox`) for the set icon.
//        • .none   plain tinted glass
//        • .linear subtle tilted linear gradient + gentle shimmer (price finishes)
//        • .holo   rotating conic holo + shimmer (rare)
//        • .mythic holo + shimmer + breathing rim (mythic)
//

// MARK: Imports

import SwiftUI

// MARK: Shine Level

enum ShineLevel {
    case none
    case linear
    case holo
    case mythic
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

    @State private var rotate = 0.0
    @State private var shimmer = -1.0
    @State private var glow = false

    func body(content: Content) -> some View {
        Group {
            if level == .none {
                content.glassEffect(.regular.tint(tint), in: shape)
            } else {
                content
                    .background { holoBackground }
                    .overlay {
                        // mythic: a pulsing rim kept inside the shape so it can't be clipped boxy
                        if level == .mythic {
                            shape
                                .stroke(tint.mix(with: .white, by: 0.6), lineWidth: glow ? 2.5 : 1)
                                .opacity(glow ? 1 : 0.45)
                                .blur(radius: 1.2)
                        }
                    }
                    .onAppear(perform: startAnimations)
            }
        }
    }

    // MARK: Layers

    private var holoBackground: some View {
        GeometryReader { geo in
            ZStack {
                if level == .linear {
                    // calmer: tilted left-to-right gradient (diagonal bands), oversized so its
                    // straight edges clip outside the shape, translucent
                    Rectangle()
                        .fill(LinearGradient(
                            colors: colors,
                            startPoint: UnitPoint(x: 0, y: 0.1),
                            endPoint: UnitPoint(x: 1, y: 0.9)
                        ))
                        .frame(width: geo.size.width * 1.4, height: geo.size.height * 1.8)
                        .opacity(0.55)
                } else {
                    // rotating conic holo — square big enough to cover at every angle
                    AngularGradient(
                        gradient: Gradient(colors: colors + [colors.first ?? tint]),
                        center: .center
                    )
                    .frame(
                        width: max(geo.size.width, geo.size.height) * 1.9,
                        height: max(geo.size.width, geo.size.height) * 1.9
                    )
                    .rotationEffect(.degrees(rotate))
                }

                // diagonal shimmer sweep, tall enough that its ends clip outside the shape
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.clear, .white.opacity(level == .linear ? 0.4 : 0.65), .clear],
                        startPoint: .leading, endPoint: .trailing
                    ))
                    .frame(width: geo.size.width * 0.6, height: geo.size.height * 2.2)
                    .rotationEffect(.degrees(22))
                    .offset(x: shimmer * geo.size.width)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .clipShape(shape)
        .glassEffect(.clear, in: shape)
    }

    // MARK: Animations

    private func startAnimations() {
        withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)) {
            rotate = 360
        }
        withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: false).delay(0.4)) {
            shimmer = 1.0
        }
        if level == .mythic {
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}
