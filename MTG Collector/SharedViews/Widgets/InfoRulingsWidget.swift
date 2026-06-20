//
//  InfoRulingsWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Card rulings as a list of independently-collapsible rows inside one widget box (the section
//      title lives outside, in CardInfoView). Rulings have no titles of their own, so each row is
//      headed "N SOURCE Date" (e.g. "1 WOTC Oct 4, 2004") with its own chevron; tapping expands just
//      that ruling's text. The owner (CardInfoView) fetches from `rulings_uri` and only shows this
//      when there's at least one. Symbols ({T}, {X}…) render via OracleTextView.
//  External Types:
//      Ruling, OracleTextView
//

// MARK: Imports

import SwiftUI

// MARK: Model

/// One Scryfall ruling (source + date + the ruling text).
struct Ruling: Identifiable, Hashable {
    let id = UUID()
    let source: String
    let publishedAt: String
    let comment: String
}

// MARK: Widget

struct InfoRulingsWidget: View {

    /// Non-empty — the owner only renders this widget when there are rulings to show.
    let rulings: [Ruling]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(rulings.enumerated()), id: \.element.id) { index, ruling in
                RulingRow(number: index + 1, ruling: ruling)
                if index < rulings.count - 1 { Divider() }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(15)
        .widgetStyle()
    }
}

// MARK: Row

/// A single ruling: a "N SOURCE Date" header with a chevron, expanding to its comment.
private struct RulingRow: View {

    let number: Int
    let ruling: Ruling

    @State private var expanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }
            } label: {
                HStack(spacing: 8) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .rotationEffect(.degrees(expanded ? 0 : -90))
                }
                .contentShape(Rectangle())
                .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)

            if expanded {
                OracleTextView(text: ruling.comment, fontSize: 15)
                    .transition(.opacity)
            }
        }
        .padding(.vertical, 8)
    }

    // MARK: Title

    /// "1 WOTC Oct 4, 2004" — number, uppercased source, and a friendly date.
    private var title: String {
        let source = ruling.source.isEmpty ? "" : ruling.source.uppercased()
        let date = Self.prettyDate(ruling.publishedAt)
        return [String(number), source, date].filter { !$0.isEmpty }.joined(separator: " ")
    }

    private static let inputFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    /// "2004-10-04" → "Oct 4, 2004"; falls back to the raw string if it doesn't parse.
    private static func prettyDate(_ raw: String) -> String {
        guard let date = inputFormatter.date(from: raw) else { return raw }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
