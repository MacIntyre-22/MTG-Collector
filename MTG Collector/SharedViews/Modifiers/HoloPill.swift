//
//  HoloPill.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      "Foil" treatment for glass chips: a rarity/finish-coloured gradient read through clear
//      Liquid Glass so it looks like light catching a foil. Two shapes are supported — a capsule
//      (`holoPill`) for small chips and a rounded box (`holoBox`) for the set icon.
//        • .none    plain tinted glass
//        • .linear  subtle tilted linear gradient + gentle shimmer (price finishes)
//        • .holo    rotating conic holo + shimmer (rare)
//        • .mythic  holo + shimmer + breathing rim (mythic)
//        • .special dual counter-rotating conics (iridescent interference) + radial sparkle (special/timeshifted)
//

// MARK: Imports

import SwiftUI

// MARK: Shine Level

enum ShineLevel {
    case none
    case linear
    case holo
    case mythic
    /// Dual counter-rotating conics + violet rim + lilac sparkle — special/timeshifted/bonus.
    case special

    /// Violet-dominant iridescence for the special tier. Mostly purple with a white sheen and a
    /// single magenta accent, so it reads clearly as purple (the card's own colour) rather than a
    /// full rainbow — the dual counter-rotating conics still make it shift from every angle.
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

    @State private var rotate = 0.0
    @State private var rotateBack = 0.0      // counter-rotation for .special interference layer
    @State private var shimmer = -1.0
    @State private var glow = false
    @State private var sparkle: CGFloat = 0  // radial pulse brightness for .special

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
                        // special: a soft lilac radial flash from the centre + a breathing violet
                        // rim, so it reads as a premium purple treatment distinct from mythic's warm glow
                        if level == .special {
                            GeometryReader { geo in
                                let r = max(geo.size.width, geo.size.height)
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 0.85, green: 0.70, blue: 1.0).opacity(sparkle * 0.4),
                                        .clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: r
                                )
                            }
                            .clipShape(shape)

                            shape
                                .stroke(Color(red: 0.72, green: 0.45, blue: 1.0), lineWidth: glow ? 2.2 : 0.8)
                                .opacity(glow ? 0.9 : 0.35)
                                .blur(radius: 1)
                        }
                    }
                    .onAppear(perform: startAnimations)
            }
        }
    }

    // MARK: Layers

    private var holoBackground: some View {
        GeometryReader { geo in
            let side = max(geo.size.width, geo.size.height) * 1.9
            ZStack {
                if level == .linear {
                    // calmer: tilted left-to-right gradient (diagonal bands), translucent
                    Rectangle()
                        .fill(LinearGradient(
                            colors: colors,
                            startPoint: UnitPoint(x: 0, y: 0.1),
                            endPoint: UnitPoint(x: 1, y: 0.9)
                        ))
                        .frame(width: geo.size.width * 1.4, height: geo.size.height * 1.8)
                        .opacity(0.55)

                } else if level == .special {
                    // two counter-rotating conics — the interference between them creates an
                    // iridescent shimmer that looks different from every angle
                    AngularGradient(gradient: Gradient(colors: colors + [colors.first ?? tint]), center: .center)
                        .frame(width: side, height: side)
                        .rotationEffect(.degrees(rotate))
                        .opacity(0.6)
                    AngularGradient(gradient: Gradient(colors: colors.reversed() + [colors.last ?? tint]), center: .center)
                        .frame(width: side, height: side)
                        .rotationEffect(.degrees(-rotateBack))
                        .opacity(0.45)
                        .blendMode(.screen)

                } else {
                    // .holo / .mythic: single rotating conic
                    AngularGradient(gradient: Gradient(colors: colors + [colors.first ?? tint]), center: .center)
                        .frame(width: side, height: side)
                        .rotationEffect(.degrees(rotate))
                }

                // diagonal shimmer sweep for all animated levels
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
        switch level {
        case .none, .linear:
            break

        case .holo, .mythic:
            withAnimation(.linear(duration: 7).repeatForever(autoreverses: false)) { rotate = 360 }
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: false).delay(0.4)) { shimmer = 1.0 }
            if level == .mythic {
                withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) { glow = true }
            }

        case .special:
            // forward conic slightly slower, reverse conic faster — ensures the two gradients
            // drift apart continuously so the violet interference never locks into a static pattern
            withAnimation(.linear(duration: 9).repeatForever(autoreverses: false)) { rotate = 360 }
            withAnimation(.linear(duration: 5.5).repeatForever(autoreverses: false)) { rotateBack = 360 }
            // gentle shimmer sweep
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false).delay(0.2)) { shimmer = 1.0 }
            // radial sparkle: pulses in and out on its own slower cycle
            withAnimation(.easeInOut(duration: 1.4).repeatForever(autoreverses: true).delay(0.6)) { sparkle = 1 }
            // breathing violet rim, offset from the sparkle so the two never peak together
            withAnimation(.easeInOut(duration: 1.7).repeatForever(autoreverses: true)) { glow = true }
        }
    }
}
