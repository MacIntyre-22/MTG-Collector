//
//  InfoDisplayWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays basic card / card-face info: name, type line, colour identity, oracle text,
//      produced mana (for lands/mana dorks) and flavor text.

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoDisplayWidget: View {

    // MARK: Stored Properties

    var name: String?
    var typeLine: String?
    var colorIdentity: [String]?
    var oracleText: String?
    var producedMana: [String] = []
    var flavorText: String = ""

    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            if let name = name {
                Text(name)
                    .bold()
            }
            if let typeLine = typeLine {
                Text(typeLine)
                    .italic()
            }
            if let colors = colorIdentity {
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
            if let text = oracleText {
                Text("\"\(text)\"")
                    .font(.custom("ManaMTG", size: 18))
                    .italic()
                    .lineSpacing(1.3)
                    .padding(.bottom, 10)
            }

            // Produced mana (lands / mana producers)
            if !producedMana.isEmpty {
                HStack(spacing: 6) {
                    Text("Produces")
                        .font(.caption)
                        .foregroundColor(.gray)
                    ForEach(producedMana, id: \.self) { color in
                        Image(color)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                }
                .padding(.bottom, 6)
            }

            // Flavor text
            if !flavorText.isEmpty {
                Text(flavorText)
                    .font(.callout)
                    .italic()
                    .foregroundColor(.secondary)
            }
        }
    }
}
