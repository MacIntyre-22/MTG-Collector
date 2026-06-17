//
//  HighCardWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-14.
//  Purpose:
//      Displays the collection's highest priced card. Takes the Scryfall ID stored on
//      CollectionStats and resolves the full card via CardStore.
//  External Types:
//      Card, CardStore, CardImageView, GridRarityWidget, GridPriceWidget

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct HighCardWidget: View {

    // MARK: Stored Properties

    var cardID: String

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var card: Card?

    // MARK: View

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("Highest Priced Card")
                    .font(.title3)
                    .bold()
                HStack(spacing: 20) {
                    CardImageView(maxWidth: 100, name: card?.name ?? "", imageURIs: card?.imageURIs ?? ImageURIs())
                    VStack(alignment: .leading) {
                        Text(card?.name ?? "Loading…")
                        // show rarity
                        if let card, !card.rarity.isEmpty {
                            GridRarityWidget(rarity: card.rarity)
                        }

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // show price
                                if let card {
                                    if !card.prices.usd.isEmpty {
                                        GridPriceWidget(finish: "Base", price: card.prices.usd)
                                    }
                                    if !card.prices.usdFoil.isEmpty {
                                        GridPriceWidget(finish: "Foil", price: card.prices.usdFoil)
                                    }
                                    if !card.prices.usdEtched.isEmpty {
                                        GridPriceWidget(finish: "Etched", price: card.prices.usdEtched)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .padding(20)
            .widgetStyle()
        }
        .task {
            if card == nil {
                card = await CardStore.resolve(cardID, context: modelContext)
            }
        }
    }
}
