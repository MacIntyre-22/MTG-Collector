//
//  InfoPurchaseWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-02.
//

import SwiftUI

struct InfoPurchaseWidget: View {
    var purchaseURIs: PurchaseURIs
    
    // bindings to display web kit sheet in info view
    @Binding var sheetIsShowing: Bool
    @Binding var webURI: URL
    
    var body: some View {
        
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    // display each price from prices obj
                    if let url = URL(string: purchaseURIs.tcgplayer) {
                        Button(action: {
                            // set sheet value and uri
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
                            // set sheet value and uri
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
                            // set sheet value and uri
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
                    .shadow(color: .gray.opacity(0.25), radius: 15, x: 0, y: 0)
            )
        }
    }
}


