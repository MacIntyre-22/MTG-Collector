//
//  CapsuleShine.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      A soft band of light that sweeps left→right across a capsule-shaped view on a loop — the same
//      glint used on the Pro crown, packaged as a reusable `.capsuleShine()` modifier for buttons.
//

// MARK: Imports

import SwiftUI

// MARK: Modifier

struct CapsuleShine: ViewModifier {

    var duration: Double = 2.8
    var intensity: Double = 0.5
    /// -1 = band off the leading edge, 1 = off the trailing edge.
    @State private var phase: CGFloat = -1
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geo in
                LinearGradient(
                    colors: [.clear, .white.opacity(intensity), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 50, height: geo.size.height * 2)
                .blur(radius: 5)
                .rotationEffect(.degrees(18))
                // Travel runs past both edges so the band fully clears the capsule at each end.
                .offset(x: phase * (geo.size.width / 2 + 50))
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
            .clipShape(Capsule())
            .allowsHitTesting(false)
        }
        .onAppear {
            // No sweep under Reduce Motion — the band stays parked off-screen.
            guard !reduceMotion else { return }
            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

extension View {
    /// Sweep a soft glint across a capsule-shaped view (e.g. a `.buttonBorderShape(.capsule)` button).
    func capsuleShine(duration: Double = 2.8, intensity: Double = 0.5) -> some View {
        modifier(CapsuleShine(duration: duration, intensity: intensity))
    }
}
