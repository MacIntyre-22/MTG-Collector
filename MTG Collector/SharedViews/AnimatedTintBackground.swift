//
//  AnimatedTintBackground.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      A full-screen wash of slowly drifting, heavily-blurred blobs in a given colour, over the
//      system background. Used behind the onboarding flow and the Pro sheet to give a living,
//      branded backdrop without any imagery.
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct AnimatedTintBackground: View {

    var tint: Color
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Color(.systemBackground)

            blob(opacity: 0.55, size: 340)
                .offset(x: animate ? -130 : 110, y: animate ? -230 : -120)
            blob(opacity: 0.40, size: 300)
                .offset(x: animate ? 150 : -90, y: animate ? 230 : 150)
            blob(opacity: 0.30, size: 260)
                .offset(x: animate ? -150 : 130, y: animate ? 120 : -180)
        }
        .blur(radius: 70)
        .ignoresSafeArea()
        .onAppear {
            // Hold still for Reduce Motion — the gradient stays a calm, static wash.
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 9).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }

    private func blob(opacity: Double, size: CGFloat) -> some View {
        Circle()
            .fill(tint.opacity(opacity))
            .frame(width: size, height: size)
    }
}
