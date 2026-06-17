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
    @State private var commanderColors: [String] = []

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
                    PricePill(stats: deck.stats)
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
        .task {
            if let commander = deck.commander, commanderColors.isEmpty {
                commanderColors = await CardStore.resolve(commander.scryfallCardID, context: modelContext)?.colors ?? []
            }
        }
    }

    // MARK: Subviews

    @ViewBuilder
    private var cover: some View {
        if let image = ImageManager.fetchImage(withIdentifier: deck.id) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            Image("MtgDeck")
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
                    .foregroundColor(Color.accentColor)
            }
            Spacer()
            HStack {
                // Commander colour identity (resolved from cache)
                ForEach(commanderColors, id: \.self) { color in
                    Image(color)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .shadow(radius: 4)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
