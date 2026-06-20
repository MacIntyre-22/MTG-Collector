//
//  LegalWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-11.
//  Purpose:
//      A widget display for the legality of a deck. When an explainer is supplied and beginner hints
//      are on, the tile becomes tappable (with a subtle info cue) and opens the shared InfoSheet
//      describing the format and what its Legal / Not-Legal status means.
//  External Types:
//      InfoDetail, InfoSheet

// MARK: Imports

import SwiftUI

// MARK: Types

struct LegalWidget: View {

    // MARK: Stored Properties

    var isLegal: Bool
    var ruleType: String
    /// Optional tap-to-learn explainer for the format + legality (shown only with beginner hints on).
    var info: InfoDetail? = nil

    // MARK: State

    @Environment(\.beginnerHints) private var beginnerHints
    @State private var openInfo: InfoDetail?

    private var tappable: Bool { beginnerHints && info != nil }

    // MARK: View

    var body: some View {
        Group {
            if tappable {
                Button { openInfo = info } label: { tile }
                    .buttonStyle(.plain)
            } else {
                tile
            }
        }
        .sheet(item: $openInfo) { InfoSheet(detail: $0) }
    }

    private var tile: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                HStack {
                    Image(systemName: isLegal ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundColor(isLegal ? .green : .red)
                    Text("\(ruleType.capitalized)")
                        .foregroundColor(.gray)
                        .italic()
                }
                Text(isLegal ? "Legal" : "Not Legal")
                    .foregroundColor(.white)
                    .bold()
                    .padding(5)
                    .background(isLegal ? .green : .red)
                    .cornerRadius(5)
            }
            .frame(maxWidth: 270, maxHeight: 100)
            .aspectRatio(1, contentMode: .fill)
            .padding(20)
            .widgetStyle()

            // Subtle "tap to learn" cue — only when beginner hints are on.
            if tappable {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(12)
            }
        }
    }
}
