//
//  CardGridView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//      Displays a card model with some previews for that card
//  External Types:
//      Card, CardFace, CardimageView, GridRarityWidget, GridPriceWidget

// MARK: Imports

import SwiftUI

// MARK: Types

struct CardGridView: View {
    
    // MARK: Stored Properties

    var card: Card
    var showPreviews: Bool = false
    /// The owned finish — drives the iridescent border (foil/etched). Nonfoil shows no border.
    var finish: CardFinish = .nonfoil
    var showNames: Bool = false

    // MARK: State Properties

    @Environment(\.appCurrency) private var currency
    @State private var isFlipped: Bool = false
    
    // MARK: Computed Properties
    
    /// Only cards where each face carries its own art (transform / modal DFCs) are treated as
    /// multi-image. Adventure, split, and flip cards have two face objects but share one top-level
    /// image — their faces have empty imageURIs, so we fall through to card.imageURIs instead.
    var multiFaced: [CardFace]? {
        let faces = card.cardFaces
        guard faces.count > 1 else { return nil }
        let withArt = faces.filter { !$0.imageURIs.normal.isEmpty || !$0.imageURIs.png.isEmpty }
        return withArt.count > 1 ? faces : nil
    }
    
    // MARK: View
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                /// if multifaced
                if let faces = multiFaced, faces.count > 1 {
                    /// Front face
                    CardImageView(maxWidth: 220, name: faces.first!.name, imageURIs: faces.first!.imageURIs)
                        .opacity(isFlipped ? 0 : 1)
                        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                    /// Back face
                    CardImageView(maxWidth: 220, name: faces.last!.name, imageURIs: faces.last!.imageURIs)
                        .opacity(isFlipped ? 1 : 0)
                        .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))

                } else {
                    /// Single faced card
                    CardImageView(maxWidth: 220, name: card.name, imageURIs: card.imageURIs)
                }
                
                /// set flip button over both faces if it is multifaced
                if let faces = multiFaced, faces.count > 1 {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    isFlipped.toggle()
                                }
                            } label: {
                                Image(systemName: "arrow.left.arrow.right.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .shadow(radius: 7)
                            }
                        }
                        Spacer()
                    }
                    .padding(4)
                }
            }
            .aspectRatio(0.714, contentMode: .fit)
            .cornerRadius(8)
            .cardFinish(finish, cornerRadius: 8)
            .padding([.horizontal, .top], 10)

            if showPreviews {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if !card.rarity.isEmpty {
                            GridRarityWidget(rarity: card.rarity)
                        }
                        ForEach(currency.cardPrices(card.prices), id: \.finish) { item in
                            GridPriceWidget(finish: item.finish, price: item.price)
                        }
                    }
                    // small vertical room for the pill shadows; horizontal inset so the row
                    // doesn't sit flush against the card edge but can still scroll to it
                    .padding(.vertical, 2)
                    .padding(.horizontal, 10)
                }
            }
        }
        .padding(.bottom, 10)
    }
    
}

