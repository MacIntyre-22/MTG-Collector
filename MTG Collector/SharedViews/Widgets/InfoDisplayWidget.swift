//
//  InfoDisplayWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays the core printed info for a card or card face: name, mana cost, type line,
//      colour identity, stats, keywords, produced mana, oracle text and flavour text.

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

    /// Power/toughness, loyalty or defense — whichever the card actually has.
    private var statLine: String? {
        if let p = power, let t = toughness, !p.isEmpty, !t.isEmpty { return "\(p)/\(t)" }
        if let l = loyalty, !l.isEmpty { return "Loyalty \(l)" }
        if let d = defense, !d.isEmpty { return "Defense \(d)" }
        return nil
    }

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            /// Name + mana cost, left-aligned together.
            HStack(alignment: .firstTextBaseline) {
                if let name = name {
                    Text(name).bold()
                }
                if let manaCost = manaCost, !manaCost.isEmpty {
                    Text(manaCost)
                        .font(.custom("ManaMTG", size: 18))
                }
                Spacer()
            }

            if let typeLine = typeLine {
                Text(typeLine).italic()
            }

            if let colors = colorIdentity, !colors.isEmpty {
                HStack {
                    ForEach(colors, id: \.self) { color in
                        Image(color)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
            }

            /// Stats + mana value.
            HStack(spacing: 14) {
                if let statLine = statLine {
                    Text(statLine).bold()
                }
                if let cmc = cmc {
                    Text("Mana Value \(Int(cmc))")
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            if let keywords = keywords, !keywords.isEmpty {
                Text(keywords.joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let produced = producedMana, !produced.isEmpty {
                HStack(spacing: 4) {
                    Text("Produces:")
                        .foregroundStyle(.secondary)
                    ForEach(produced, id: \.self) { symbol in
                        Image(symbol)
                            .resizable()
                            .frame(width: 18, height: 18)
                    }
                    Spacer()
                }
                .padding(.top, 2)
            }

            if let text = oracleText, !text.isEmpty {
                Text(text)
                    .font(.custom("ManaMTG", size: 18))
                    .lineSpacing(1.3)
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
