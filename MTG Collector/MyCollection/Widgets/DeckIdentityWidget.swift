//
//  DeckIdentityWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      The deck's colour identity (WUBRG, auto-set from the leaders) plus the Commander-rule check:
//      every card's colour identity must sit inside the deck's. Shows a green "all match" when the
//      deck is clean, or an amber warning naming how many cards fall outside — the single most common
//      Commander deckbuilding mistake. Purely presentational; the count is computed by the stats sheet.
//  External Types:
//      OracleSymbolImage
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct DeckIdentityWidget: View {

    // MARK: Stored Properties

    /// The deck's colour identity in WUBRG order (empty == colourless).
    let identity: [String]
    /// Unique mainboard cards whose colour identity falls outside the deck's.
    let offenders: Int

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Colour Identity")
                .font(.headline)

            HStack(spacing: 6) {
                if identity.isEmpty {
                    Text("Colourless")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(identity, id: \.self) { colour in
                        OracleSymbolImage(symbol: "{\(colour)}", size: 24)
                    }
                }
                Spacer()
            }

            Divider()

            HStack(spacing: 8) {
                Image(systemName: offenders == 0 ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .foregroundStyle(offenders == 0 ? .green : .orange)
                Text(offenders == 0
                     ? "All cards match the deck's identity"
                     : "^[\(offenders) card](inflect: true) outside this identity")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: 600)
        .widgetStyle()
    }
}
