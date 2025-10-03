//
//  CardInfoView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardInfoView: View {
    // data
    var card: Card
    
    // dummy url for webkit
    @State var webURI: URL = URL(string: "about:blank")!
    @State var sheetIsShowing: Bool = false
    
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            // The main scrollable list
            List {
                Section(header: Label("Information", systemImage: "info.circle")) {
                    VStack(spacing: 8) {
                        // handle muliple faces
                        if !card.cardFaces.isEmpty {
                            
                            ForEach(card.cardFaces) { face in
                                InfoDisplayWidget(name: face.name, typeLine: face.typeLine, colorIdentity: card.colorIdentity, oracleText: face.oracleText)
                                    .padding(.bottom, 10)
                            }
                        } else {
                            InfoDisplayWidget(typeLine: card.typeLine, colorIdentity: card.colorIdentity, oracleText: card.oracleText)
                        }
                    }
                }
                
                Section(header: Label("Legalities", systemImage: "book.circle")) {
                    // Legalities info here
                    InfoLegalWidget(legalities: card.legalities)
                }
                
                Section(header: Label("Related Cards", systemImage: "plus.circle")) {
                    // related card items
                    InfoRelatedWidget(cardParts: card.allParts)
                }
                
                Section(header: Label("Pricing", systemImage: "tag.circle")) {
                    // pricing info
                    InfoPriceWidget(prices: card.prices)
                }
                
                Section(header: Label("Purchase Links", systemImage: "link.circle")) {
                    // purchase links here
                    InfoPurchaseWidget(purchaseURIs: card.purchaseURIs, sheetIsShowing: $sheetIsShowing, webURI: $webURI)
                }
                
                Section(header: Label("Other", systemImage: "ellipsis.circle")) {
                    // Additional info here
                    InfoOtherWidget(releasedAt: card.releasedAt, finishes: card.finishes, set: card.set, reserved: card.reserved)
                }
            }
            .navigationTitle(card.name)
            .listRowSpacing(10)
            
            // Floating cards
            HStack(){
                Spacer()
                HStack(spacing: 8) {
                    if !card.cardFaces.isEmpty {
                        ForEach(card.cardFaces) { face in
                            CardImageView(maxWidth: 75, imageURIs: face.imageURIs)
                        }
                    } else {
                        CardImageView(maxWidth: 100, imageURIs: card.imageURIs)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                
                .shadow(radius: 4)
            }
            .frame(height: 150)
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                CollectionControllWidget(card: card)
            }
        })
        .sheet(isPresented: $sheetIsShowing) {
            WebSheet(url: webURI)
        }
    }
}

