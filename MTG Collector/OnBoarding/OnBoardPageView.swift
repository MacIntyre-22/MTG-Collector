//
//  OnBoardPageView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-30.
//  Purpose:
//      One onboarding page: a polished icon badge (the app icon, or an SF Symbol in a tinted gradient
//      circle) above a title and a short description.
//  External Types:
//      PageInfo
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct OnBoardPageView: View {

    // MARK: Stored Properties

    var pageInfo: PageInfo
    /// True when this is the page currently on screen — drives the settle-in animation.
    var isActive: Bool = true

    @Environment(\.appTint) private var tint
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    /// Continuous gentle bob of the badge.
    @State private var float = false

    // MARK: View

    var body: some View {
        VStack(alignment: .center, spacing: 26) {
            badge
                .offset(y: float ? -8 : 0)
                .scaleEffect(isActive ? 1 : 0.86)
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: isActive)
            VStack(spacing: 12) {
                Text(pageInfo.title)
                    .font(BrandFont.wordmark(36, relativeTo: .largeTitle))
                    .multilineTextAlignment(.center)
                Text(pageInfo.text)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 28)
            .opacity(isActive ? 1 : 0)
            .offset(y: isActive ? 0 : 16)
            .animation(.easeOut(duration: 0.4), value: isActive)
        }
        .padding(30)
        .onAppear {
            // Skip the continuous bob under Reduce Motion.
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                float = true
            }
        }
    }

    // MARK: Badge

    /// Every page uses the same tinted gradient circle. The welcome page shows the app icon
    /// centred inside it; tab pages show an SF Symbol.
    private var badge: some View {
        ZStack {
            Circle()
                .fill(tint.gradient)
                .frame(width: 150, height: 150)
                .shadow(color: tint.opacity(0.4), radius: 22, y: 8)

            if let asset = pageInfo.asset {
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 92, height: 92)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .shadow(color: .black.opacity(0.25), radius: 8, y: 4)
            } else {
                Image(systemName: pageInfo.image)
                    .font(.system(size: 60, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
}
