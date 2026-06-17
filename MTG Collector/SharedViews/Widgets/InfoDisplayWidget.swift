//
//  InfoDisplayWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays the core printed info for a card or card face: name, mana cost, type line,
//      colour identity, stats, keywords, produced mana, oracle text and flavour text.
//      All mana/game symbols are rendered from cached Scryfall SVGs via OracleTextView / ManaCostView.
//  External Types:
//      ManaCostView, SymbolRowView, OracleTextView
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoDisplayWidget: View {

    // MARK: Stored Properties

    var name: String?
    var manaCost: String?
    var cmc: Double?
    var typeLine: String?
    var colorIdentity: [String]?
    var power: String?
    var toughness: String?
    var loyalty: String?
    var defense: String?
    var keywords: [String]?
    var producedMana: [String]?
    var oracleText: String?
    var flavorText: String?

    // MARK: Computed

    private var statLine: String? {
        if let p = power, let t = toughness, !p.isEmpty, !t.isEmpty { return "\(p)/\(t)" }
        if let l = loyalty, !l.isEmpty { return "Loyalty \(l)" }
        if let d = defense, !d.isEmpty { return "Defense \(d)" }
        return nil
    }

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Name + mana cost
            HStack(alignment: .center, spacing: 8) {
                if let name {
                    Text(name).bold()
                }
                if let manaCost, !manaCost.isEmpty {
                    ManaCostView(cost: manaCost, symbolSize: 20)
                }
                Spacer()
            }

            if let typeLine {
                Text(typeLine).italic()
            }

            // Colour identity pips
            if let colors = colorIdentity, !colors.isEmpty {
                SymbolRowView(colorLetters: colors, symbolSize: 22)
                    .padding(.vertical, 3)
            }

            // Power/toughness, loyalty, mana value
            HStack(spacing: 14) {
                if let statLine {
                    Text(statLine).bold()
                }
                if let cmc {
                    Text("Mana Value \(Int(cmc))")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            if let keywords, !keywords.isEmpty {
                Text(keywords.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Produced mana
            if let produced = producedMana, !produced.isEmpty {
                HStack(spacing: 6) {
                    Text("Produces:")
                        .foregroundStyle(.secondary)
                    SymbolRowView(colorLetters: produced, symbolSize: 20)
                    Spacer()
                }
                .padding(.top, 2)
            }

            // Oracle text with inline symbols, reminder text, loyalty costs
            if let text = oracleText, !text.isEmpty {
                OracleTextView(text: text, fontSize: 14)
                    .padding(.top, 6)
            }

            if let flavor = flavorText, !flavor.isEmpty {
                Text(flavor)
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.top, 6)
            }
        }
    }
}
