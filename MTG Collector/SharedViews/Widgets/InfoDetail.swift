//
//  InfoDetail.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      The reusable "tap a pill → read a plain-language explainer" flow, generalised out of the
//      keyword glossary so any explainable thing can use it (keywords, card traits like Alchemy /
//      Reserved List / card-type layouts, and whatever else gets added later):
//        • InfoDetail — a value describing one explainable item (title, icons, coloured category
//          badge, body text). Identifiable so it drives `.sheet(item:)`.
//        • InfoPill   — the tappable chip that opens the sheet.
//        • InfoSheet  — the small sheet: title label, coloured category badge, optional family
//          blurb, then the definition rendered through the oracle engine (so inline {T}/{1} show).
//      Aimed at beginners; minimal so it never clutters the UI for experienced players.
//  External Types:
//      OracleTextView
//

// MARK: Imports

import SwiftUI

// MARK: - Beginner hints environment

/// Whether to surface beginner "tap to learn" cues on functional elements (deck roles, legality…).
/// Driven by Settings.beginnerHints, injected at the app root. Default true.
private struct BeginnerHintsKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

extension EnvironmentValues {
    var beginnerHints: Bool {
        get { self[BeginnerHintsKey.self] }
        set { self[BeginnerHintsKey.self] = newValue }
    }
}

// MARK: - Model

/// One explainable item shown via an info pill + sheet.
struct InfoDetail: Identifiable {
    let id: String
    /// Icon for the sheet's title label (and the pill's leading icon, when shown).
    let symbol: String
    let title: String
    /// Optional coloured badge under the title (e.g. "Keyword Ability", "Card Type").
    let category: String?
    let categoryIcon: String?
    /// Accent colour for the badge and the pill's question mark.
    let tint: Color
    /// Optional one-line explainer of the *category* (used by keywords; nil for most traits).
    let blurb: String?
    /// The body text, rendered through the oracle engine.
    let definition: String
}

// MARK: - Pill

/// A tappable capsule chip that opens an InfoDetail sheet. Matches the keyword-chip styling.
struct InfoPill: View {
    let title: String
    var leadingIcon: String? = nil
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let leadingIcon {
                    Image(systemName: leadingIcon).font(.footnote)
                }
                Text(title).font(.subheadline.weight(.semibold))
                Image(systemName: "questionmark.circle").font(.footnote)
                    .foregroundStyle(tint)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(Capsule().fill(Color.primary.opacity(0.08)))
            .foregroundStyle(.primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Sheet

/// The small explainer sheet: title + coloured family badge + optional blurb + definition.
struct InfoSheet: View {
    let detail: InfoDetail

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Label {
                    Text(detail.title)
                } icon: {
                    Image(systemName: detail.symbol)
                }
                .font(.title.bold())

                if let category = detail.category {
                    HStack(spacing: 6) {
                        if let categoryIcon = detail.categoryIcon {
                            Image(systemName: categoryIcon).font(.caption.weight(.semibold))
                        }
                        Text(category).font(.caption.weight(.semibold))
                    }
                    .foregroundStyle(detail.tint)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(detail.tint.opacity(0.12)))
                }

                if let blurb = detail.blurb {
                    Text(blurb)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Divider().padding(.vertical, 2)

                // Oracle engine so inline {T}/{1}/{W/B} symbols render; sized to match .body.
                OracleTextView(text: detail.definition, fontSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(24)
        }
        .presentationDetents([.fraction(0.4), .large])
        .presentationDragIndicator(.visible)
    }
}
