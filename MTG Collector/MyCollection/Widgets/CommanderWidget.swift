//
//  CommanderWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-09.
//  Purpose:
//      Used to display a deck's commander card if it has one. Resolves the card via CardStore.
//  External Types:
//      CardEntry, Card, CardStore, CardInfoView, CardImageView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CommanderWidget: View {

    // MARK: Stored Properties

    var entry: CardEntry
    var remove: () -> Void

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appTint) private var tint
    @State private var card: Card?

    // MARK: View

    var body: some View {
        NavigationLink {
            if let card {
                CardInfoView(card: card)
            }
        } label: {
            HStack {
                CardImageView(maxWidth: 85, name: card?.name ?? "", imageURIs: card?.imageURIs ?? ImageURIs())

                VStack(alignment: .leading) {
                    Text("Commander")
                        .bold()
                    Text(card?.name ?? "Loading…")
                    HStack {
                        // Multi-face card
                        ForEach(card?.colors ?? [], id: \.self) { color in
                            OracleSymbolImage(symbol: "{\(color)}", size: 24)
                        }
                        Spacer()
                    }

                    Menu {
                        Button("Remove") {
                            remove()
                        }
                    } label: {
                        Image(systemName: "pencil.line")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(tint)
                            .cornerRadius(5)
                            .bold()
                            .shadow(radius: 4)
                    }
                    Spacer()
                }
                .foregroundColor(.primary)
                .padding(.vertical, 5)
            }
            .padding(10)
            .widgetStyle(.translucent)
            .frame(maxWidth: 600)
        }
        .task {
            if card == nil {
                card = await CardStore.resolve(entry.scryfallCardID, context: modelContext)
            }
        }
    }
}
