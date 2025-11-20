//
//  InfoPurchaseWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-02.
//  Purpose:
//      Displays different links to vendors for the card from a PurchaseURIs object
//  Externa Types:
//      PurchaseURIs

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoPurchaseWidget: View {
    
    // MARK: Stored Properties

    var purchaseURIs: PurchaseURIs
    
    // MARK: State Properties

    @Binding var sheetIsShowing: Bool
    @Binding var webURI: URL
    
    // MARK: View

    var body: some View {
        
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let url = URL(string: purchaseURIs.tcgplayer) {
                        Button(action: {
                            sheetIsShowing = true
                            webURI = url
                        }) {
                            Image("TcgPlayer")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                            
                                .frame(width: 100, height: 100)
                        }
                        .background(content: {Color.gray.opacity(0.18)})
                        .cornerRadius(10)
                        
                    }
                    
                    if let url = URL(string: purchaseURIs.cardhoarder) {
                        Button(action: {
                            sheetIsShowing = true
                            webURI = url
                        }) {
                            Image("CardHoarder")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                                .frame(width: 100, height: 100)
                        }
                        .background(content: {Color.gray.opacity(0.18)})
                        .cornerRadius(10)
                        
                    }
                    
                    if let url = URL(string: purchaseURIs.cardmarket) {
                        Button(action: {
                            sheetIsShowing = true
                            webURI = url
                        }) {
                            Image("CardMarket")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                                .frame(width: 100, height: 100)
                        }
                        .background(content: {Color.gray.opacity(0.18)})
                        .cornerRadius(10)
                    }
                }
            }
            .padding(15)
            .cornerRadius(9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
}


