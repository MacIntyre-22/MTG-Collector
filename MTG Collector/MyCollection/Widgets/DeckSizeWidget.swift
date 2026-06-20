//
//  DeckSizeWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      A square stat tile for a deck's mainboard size against its format's expected count — exact for
//      singleton formats (Commander = 100), a minimum for constructed (Standard = 60+). Greens when
//      the deck meets the rule, ambers when it doesn't, so an under-built deck is obvious. Sits beside
//      the legality tile. Pairs with DeckRules.deckSize.
//  External Types:
//      DeckRules
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct DeckSizeWidget: View {

    // MARK: Stored Properties

    let count: Int
    let ruleType: String

    private var rule: (target: Int, exact: Bool)? { DeckRules.deckSize(for: ruleType) }

    /// Whether the deck satisfies its size rule (exact match, or at-or-above the minimum).
    private var meets: Bool {
        guard let rule else { return true }
        return rule.exact ? count == rule.target : count >= rule.target
    }

    // MARK: View

    var body: some View {
        VStack {
            Label("Deck Size", systemImage: "number.square")
                .foregroundColor(.gray)
                .italic()

            Text("\(count)")
                .font(.title)
                .bold()
                .lineLimit(1)

            if let rule {
                HStack(spacing: 4) {
                    Image(systemName: meets ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundStyle(meets ? .green : .orange)
                    Text(rule.exact ? "of \(rule.target)" : "\(rule.target)+ min")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("No limit")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: 270, maxHeight: 100)
        .aspectRatio(1, contentMode: .fill)
        .padding(20)
        .widgetStyle()
    }
}
