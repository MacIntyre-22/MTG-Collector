//
//  OnBoardingView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-29.
//  Purpose:
//      First-launch onboarding: a welcome page plus one page per tab, each explaining what that part
//      of the app does for a new player. Paged TabView with a Next / Get Started button.
//  External Types:
//      OnBoardPageView
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct PageInfo {

    // MARK: Stored Properties

    var title: String
    /// SF Symbol shown in the tinted badge (ignored when `asset` is set).
    var image: String
    var text: String
    /// An asset image (e.g. the app icon) shown instead of the SF Symbol badge.
    var asset: String? = nil
}

struct OnBoardingView: View {

    // MARK: Stored Properties

    var toggleOnBoarding: () -> Void
    var pages: [PageInfo] = [
        PageInfo(title: "Welcome to Cardhold",
                 image: "",
                 text: "Browse, organize and price every Magic: The Gathering card. All on your device, no account needed.",
                 asset: "CardholdIcon"),
        PageInfo(title: "Daily Discovery",
                 image: "sparkles",
                 text: "The Home tab surfaces a fresh set of cards every day: popular, pricey, budget, full-art and newly released."),
        PageInfo(title: "Find Any Card",
                 image: "magnifyingglass",
                 text: "Search Scryfall's entire database and filter by colour, type, set, format and price, or scan a real card with your camera."),
        PageInfo(title: "Build Your Collection",
                 image: "square.stack.3d.up.fill",
                 text: "Sort cards into Binders and Decks, track total value and format legality, and import or share decklists."),
    ]

    // MARK: State Properties

    @State private var currentPage = 0
    @State private var showPaywall = false
    @Environment(\.appTint) private var tint

    // MARK: View

    var body: some View {
        ZStack {
            // Opaque base so the tab behind the onboarding overlay never shows through (the blurred
            // gradient above this can fade to transparent at its edges).
            Color(.systemBackground)
                .ignoresSafeArea()

            // Soft, slowly drifting wash of the accent colour behind everything.
            AnimatedTintBackground(tint: tint)

            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    // Per-page check (not the shared currentPage) so the Pro button only ever lives
                    // on the actual last page — otherwise it flashes onto every page mid-swipe.
                    let isLast = index == pages.count - 1

                    VStack(spacing: 36) {
                        Spacer()
                        OnBoardPageView(pageInfo: pages[index], isActive: currentPage == index)

                        VStack(spacing: 14) {
                            Button {
                                if isLast {
                                    toggleOnBoarding()
                                } else {
                                    withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                        currentPage = index + 1
                                    }
                                }
                            } label: {
                                Text(isLast ? "Get Started" : "Next")
                                    .frame(maxWidth: .infinity)
                                    .fontWeight(.semibold)
                                    .padding(.vertical, 10)
                                    .contentTransition(.identity)
                            }
                            .buttonStyle(.glassProminent)
                            .buttonBorderShape(.capsule)
                            .tint(tint)

                            // Only the final page offers a peek at Pro before diving in.
                            if isLast {
                                Button { showPaywall = true } label: {
                                    HStack(spacing: 8) {
                                        Image(systemName: "crown.fill")
                                            .foregroundStyle(.yellow)
                                        Text("Explore Cardhold Pro")
                                            .foregroundStyle(.white)
                                    }
                                    .font(.subheadline.weight(.semibold))
                                    .shadow(color: .black.opacity(0.35), radius: 2, y: 1)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    // Light tint of the onboarding theme colour (the yellow fill read poorly).
                                    .pillStyle(.tinted(tint))
                                }
                                .buttonStyle(.plain)
                                .capsuleShine()
                            }
                        }
                        .padding(.horizontal, 32)
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
        }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }
}
