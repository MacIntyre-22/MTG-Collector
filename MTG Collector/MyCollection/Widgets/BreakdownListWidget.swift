//
//  BreakdownListWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      A reusable titled "label … count" list in the standard widget style, for the stats sheet's
//      breakdowns (rarity, sets, finish, roles). Items are passed pre-ordered. Rows can carry an
//      optional tap-to-learn explainer (keyed by label); when beginner hints are on, those rows
//      become tappable with a subtle cue and open the shared InfoSheet. Matches TypeCountWidget.
//  External Types:
//      InfoDetail, InfoSheet
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct BreakdownListWidget: View {

    // MARK: Stored Properties

    let title: String
    /// Pre-ordered rows to show.
    let items: [(label: String, count: Int)]
    /// Optional per-row explainer, keyed by row label. Tappable only when beginner hints are on.
    var info: [String: InfoDetail] = [:]

    // MARK: State

    @Environment(\.beginnerHints) private var beginnerHints
    @State private var openInfo: InfoDetail?

    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .bold()
                .padding(.bottom, 12)
            ForEach(items, id: \.label) { item in
                row(item)
            }
        }
        .frame(maxWidth: 600)
        .frame(minHeight: 60)
        .padding(20)
        .widgetStyle()
        .sheet(item: $openInfo) { InfoSheet(detail: $0) }
    }

    // MARK: Row

    @ViewBuilder
    private func row(_ item: (label: String, count: Int)) -> some View {
        // Tappable only when there's an explainer for this label and beginner hints are on.
        let detail = beginnerHints ? info[item.label] : nil
        if let detail {
            Button { openInfo = detail } label: { rowContent(item, showCue: true) }
                .buttonStyle(.plain)
        } else {
            rowContent(item, showCue: false)
        }
    }

    private func rowContent(_ item: (label: String, count: Int), showCue: Bool) -> some View {
        HStack(spacing: 6) {
            Text(item.label)
                .foregroundColor(.gray)
                .italic()
                .lineLimit(1)
            if showCue {
                Image(systemName: "info.circle")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(item.count)")
                .bold()
        }
        .contentShape(Rectangle())
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
    }
}
