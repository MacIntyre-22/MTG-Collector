//
//  TabGuide.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      A lightweight "what you can do here" intro shown once the first time the user lands on each
//      main tab (Home, Search, My Hold) — a short feature list with a how-to line each. Settings is
//      excluded. Presentation + once-per-tab tracking is driven from MTG_TabView; this file holds
//      the content and the sheet UI.
//  External Types:
//      AppTab
//

// MARK: Imports

import SwiftUI

// MARK: Model

/// One tab's feature intro.
struct TabGuide: Identifiable {

    /// Stable storage key suffix (also the Identifiable id), e.g. "home".
    let id: String
    let title: String
    let icon: String
    /// Optional asset image shown in the badge instead of the SF Symbol (e.g. the app logo).
    var assetIcon: String? = nil
    let features: [Feature]

    struct Feature: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let detail: String
    }

    /// Persisted "already shown" flag key for this guide.
    var seenKey: String { "tabGuideSeen_\(id)" }
}

// MARK: Content

extension TabGuide {

    /// The guide for a tab, or `nil` for tabs without one (Settings).
    static func guide(for tab: AppTab) -> TabGuide? {
        switch tab {
        case .home:       return .home
        case .search:     return .search
        case .collection: return .collection
        case .settings:   return nil
        }
    }

    /// All guides — used to reset the seen flags (dev "Show Onboarding").
    static let all: [TabGuide] = [.home, .search, .collection]

    static func resetAll() {
        for guide in all { UserDefaults.standard.removeObject(forKey: guide.seenKey) }
    }

    static let home = TabGuide(
        id: "home",
        title: "Home",
        icon: "house.fill",
        features: [
            Feature(icon: "sparkles", title: "A new discovery every day",
                    detail: "Hand-picked cards refreshed daily: the popular, the pricey, the budget gems, stunning full-art and the newest releases."),
            Feature(icon: "rectangle.stack", title: "Dive deeper",
                    detail: "Tap View All to explore every card in a theme."),
            Feature(icon: "hand.tap", title: "Tap any card",
                    detail: "Open it for crisp art, live prices and official rulings."),
            Feature(icon: "arrow.up.left.and.arrow.down.right", title: "Hold for full screen",
                    detail: "Press and hold any card to fill the screen with its art."),
        ]
    )

    static let search = TabGuide(
        id: "search",
        title: "Search",
        icon: "magnifyingglass",
        features: [
            Feature(icon: "magnifyingglass", title: "Every card ever printed",
                    detail: "Instantly search Scryfall's entire Magic database."),
            Feature(icon: "line.3.horizontal.decrease.circle", title: "Powerful filters",
                    detail: "Zero in by colour, type, set, format, mana value and price."),
            Feature(icon: "camera.viewfinder", title: "Scan with your camera",
                    detail: "Point at a real card and Cardhold finds the exact printing in a snap."),
            Feature(icon: "plus.circle", title: "One-tap collecting",
                    detail: "Found it? Add it to a binder, deck or your Hold instantly."),
        ]
    )

    static let collection = TabGuide(
        id: "collection",
        title: "My Hold",
        icon: "square.stack.3d.up.fill",
        assetIcon: "CardholdIcon",
        features: [
            Feature(icon: "square.stack", title: "Your catch-all Hold",
                    detail: "Keep every loose card in one place, no binder or deck required."),
            Feature(icon: "folder.fill", title: "Binders & decks",
                    detail: "Organize cards into binders and build full decks with leaders and boards."),
            Feature(icon: "chart.bar.fill", title: "Value & insights",
                    detail: "See total value, format legality, mana curve and colour breakdowns at a glance."),
            Feature(icon: "square.and.arrow.up", title: "Import & share",
                    detail: "Pull in decklists from text or CSV, and share any collection with a link."),
        ]
    )
}

// MARK: Sheet

/// The presented feature list. A circular tab badge, one row per feature with a how-to line, and a
/// "Got it" button.
struct TabGuideSheet: View {

    let guide: TabGuide

    @Environment(\.dismiss) private var dismiss
    @Environment(\.appTint) private var tint
    /// Measured natural height of the content, used to size the sheet to fit.
    @State private var contentHeight: CGFloat = 320

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header

                VStack(alignment: .leading, spacing: 18) {
                    ForEach(guide.features) { feature in
                        featureRow(feature)
                    }
                }

                Button { dismiss() } label: {
                    Text("Got it")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.capsule)
                .tint(tint)
                .padding(.top, 8)
            }
            .padding()
            .padding(.top, 12)
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { contentHeight = $0 }
        }
        .scrollBounceBehavior(.basedOnSize)
        // Fit the sheet to its content; .large stays available for very large Dynamic Type.
        .presentationDetents([.height(contentHeight), .large])
        .presentationDragIndicator(.visible)
    }

    private var header: some View {
        HStack(spacing: 14) {
            Group {
                if let asset = guide.assetIcon {
                    // App logo as a white template, matching the SF-symbol badges.
                    Image(asset)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                } else {
                    Image(systemName: guide.icon)
                        .font(.system(size: 28, weight: .semibold))
                }
            }
            .foregroundStyle(.white)
            .frame(width: 60, height: 60)
            .background(Circle().fill(tint.gradient))
            .shadow(color: tint.opacity(0.4), radius: 10, y: 4)
            VStack(alignment: .leading, spacing: 2) {
                Text(guide.title)
                    .font(.title2.bold())
                Text("Here's what you can do here")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 8)
    }

    private func featureRow(_ feature: TabGuide.Feature) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: feature.icon)
                .font(.title3)
                .foregroundStyle(tint)
                .frame(width: 30)
            VStack(alignment: .leading, spacing: 3) {
                Text(feature.title)
                    .font(.headline)
                Text(feature.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
