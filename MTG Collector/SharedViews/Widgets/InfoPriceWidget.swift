//
//  InfoPriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct InfoPriceWidget: View {
    var card: CardJSON
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if let usd = card.prices?.usd {
                    VStack(alignment: .leading) {
                        Text("Base")
                            .bold()
                            .italic()
                            .foregroundColor(.white)
                            .padding(5)
                            .background(LinearGradient(
                                colors: [.gray.opacity(0.3), .gray.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .cornerRadius(5)
                        Spacer()
                        Text("$\(usd)")
                            .frame(width: 80, alignment: .trailing)
                            .bold()
                            .foregroundColor(.green)
                    }
                    .padding(10)
                    .frame(width: 100, height: 100)
                    .background(content: {Color.green.opacity(0.2)})
                    .cornerRadius(10)
                }
                
                if let usd = card.prices?.usdFoil {
                    VStack(alignment: .leading) {
                        Text("Foil")
                            .bold()
                            .italic()
                            .foregroundColor(.white)
                            .padding(5)
                            .background(LinearGradient(
                                colors: [.blue, .purple, .pink, .orange, .yellow],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .cornerRadius(5)
                        Spacer()
                        Text("$\(usd)")
                            .frame(width: 80, alignment: .trailing)
                            .bold()
                            .foregroundColor(.green)
                    }
                    .padding(10)
                    .frame(width: 100, height: 100)
                    .background(content: {Color.green.opacity(0.2)})
                    .cornerRadius(10)
                }
                
                if let usd = card.prices?.usdEtched {
                    VStack(alignment: .leading) {
                        Text("Etched")
                            .bold()
                            .italic()
                            .foregroundColor(.white)
                            .padding(5)
                            .background(LinearGradient(
                                colors: [.black, .gray],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .cornerRadius(5)
                        Spacer()
                        Text("$\(usd)")
                            .frame(width: 80, alignment: .trailing)
                            .bold()
                            .foregroundColor(.green)
                    }
                    .padding(10)
                    .frame(width: 100, height: 100)
                    .background(content: {Color.green.opacity(0.2)})
                    .cornerRadius(10)
                }
            }
        }
    }
}

