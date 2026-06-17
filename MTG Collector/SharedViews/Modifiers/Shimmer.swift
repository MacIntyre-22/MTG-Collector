//
//  Shimmer.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      A lightweight shimmer effect for loading skeletons — a soft highlight sweeps across the
//      masked content on a repeating loop. Applied via `.shimmering()`.
//

// MARK: Imports

import SwiftUI

// MARK: Modifier

struct Shimmer: ViewModifier {

    @State private var move = false

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.45), .clear]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .rotationEffect(.degrees(20))
                    .offset(x: move ? geo.size.width : -geo.size.width)
                }
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                    move = true
                }
            }
    }
}

extension View {
    func shimmering() -> some View { modifier(Shimmer()) }
}
