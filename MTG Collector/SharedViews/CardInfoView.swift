//
//  CardInfoView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//      Displays all the info for a card model
//  External Types:
//      Card, InfoDisplayWidget, SetIconWidget, InfoLegalWidget, InfoRelatedWidget, InfoPriceWidget, InfoPurchaseWidget, InfoOtherWidget, CardImageView, CollectionControlWidget, WebSheet

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CardInfoView: View {

    // MARK: Stored Properties

    var card: Card
    
    // MARK: State Properties
    
    @Environment(\.modelContext) var modelContext
    @State var webURI: URL = URL(string: "about:blank")!
    @State var sheetIsShowing: Bool = false
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomLeading) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 15) {
                        ZStack {
                            VStack(alignment: .leading) {
                                
                                /// handle muliple faces
                                if !card.cardFaces.isEmpty {
                                    
                                    ForEach(card.cardFaces) { face in
                                        InfoDisplayWidget(name: face.name, typeLine: face.typeLine, colorIdentity: card.colorIdentity, oracleText: face.oracleText)
                                            .padding(.bottom, 10)
                                    }
                                } else {
                                    InfoDisplayWidget(typeLine: card.typeLine, colorIdentity: card.colorIdentity, oracleText: card.oracleText)
                                }
                                
                                SetIconWidget(set: card.set, rarity: card.rarity, maxWidth: 50)
                            }
                            .padding(15)
                            .cornerRadius(9)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.background)
                                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
                            )
                        }
                        
                        /// Legalities info here
                        InfoLegalWidget(legalities: card.legalities)
                        
                        /// related card items
                        if !card.allParts.isEmpty {
                            InfoRelatedWidget(cardParts: card.allParts)
                        }
                        
                        
                        /// pricing info
                        if !(card.prices.usd.isEmpty && card.prices.usdFoil.isEmpty && card.prices.usdEtched.isEmpty) {
                            InfoPriceWidget(prices: card.prices)
                        }
                        
                        
                        /// purchase links here
                        if !(card.purchaseURIs.cardhoarder.isEmpty && card.purchaseURIs.cardmarket.isEmpty && card.purchaseURIs.tcgplayer.isEmpty) {
                            InfoPurchaseWidget(purchaseURIs: card.purchaseURIs, sheetIsShowing: $sheetIsShowing, webURI: $webURI)
                        }
                        
                        /// Additional info here
                        InfoOtherWidget(releasedAt: card.releasedAt, finishes: card.finishes, set: card.set, reserved: card.reserved)
                        
                    }
                    .padding(.horizontal, 10)
                    
                }
                
                
                /// Floating cards
                HStack(){
                    Spacer()
                    HStack(spacing: 8) {
                        if !card.cardFaces.isEmpty {
                            ForEach(card.cardFaces) { face in
                                CardImageView(maxWidth: 75, name: face.name, imageURIs: face.imageURIs)
                            }
                        } else {
                            CardImageView(maxWidth: 100, name: card.name, imageURIs: card.imageURIs)
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
            .navigationTitle(card.name)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Add", systemImage: "plus") {
                        CollectionControllWidget(card: card)
                    }
                }
            })
            .sheet(isPresented: $sheetIsShowing) {
                WebSheet(url: webURI)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

