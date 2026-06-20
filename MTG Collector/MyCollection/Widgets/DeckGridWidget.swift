//
//  DeckGridWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-26.
//  Purpose:
//      Used as a list item in a grid to link to the respective deck. The cover is a responsive
//      square that fills its grid column (so it never overflows or overlaps neighbours).
//  External Types:
//      Deck, ImageManager, CardStore, PricePill
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct DeckGridWidget: View {

    // MARK: Stored Properties

    var deck: Deck

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appTint) private var tint

    // MARK: View

    var body: some View {
        VStack(alignment: .center) {
            // square defined by the shape (fills the column); the image fills + crops inside it
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
                .overlay { cover }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .topLeading) {
                    controls
                        .padding(5)
                }

            VStack {
                Text(deck.name)
                    .bold()
                    .lineLimit(1)
                HStack {
                    PricePill(stats: StatsStore.stats(for: deck, context: modelContext), compact: true)
                        .lineLimit(1)

                    Image(systemName: "square.stack")
                        .foregroundColor(.primary)

                    Text("\(deck.cardCount)")
                }
            }
        }
        .foregroundColor(.primary)
        .padding(10)
        .widgetStyle()
        // Make the whole tile the long-press target for the context menu, not just the cover.
        .contentShape(Rectangle())
    }

    // MARK: Subviews

    @ViewBuilder
    private var cover: some View {
        if let image = deck.coverUIImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Image("CardholdIcon")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.white)
                .padding(24)
        }
    }

    private var controls: some View {
        VStack(alignment: .leading) {
            Button {
                deck.pinned.toggle()
                HapticManager.medium()
            } label: {
                Image(systemName: deck.pinned ? "pin.fill" : "pin")
                    .resizable()
                    .frame(width: 15, height: 20)
                    .shadow(radius: 4)
                    .foregroundColor(tint)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 3) {
                // Game mode (Commander, Standard, …) sits just above the colour identity row.
                if !deck.ruleType.isEmpty {
                    Text(deck.ruleType.capitalized)
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .shadow(radius: 4)
                }

                // Deck colour identity (stored on the deck, auto-set from its leaders). Tight,
                // left-aligned spacing so a full five-colour identity still fits the tile.
                HStack(spacing: 2) {
                    ForEach(deck.colorIdentity, id: \.self) { color in
                        OracleSymbolImage(symbol: "{\(color)}", size: 20)
                            .shadow(radius: 4)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
