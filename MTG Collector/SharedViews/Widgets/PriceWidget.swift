//
//  PriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-29.
//

import SwiftUI

struct PriceWidget: View {
    var finish: String
    var price: String
    var cur: String {
        currency(finsih: finish)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(finish.capitalized)
                .bold()
                .italic()
                .foregroundColor(.white)
                .padding(5)
                .background(gradient(finish: finish))
                .cornerRadius(5)
            
            Spacer()
            
            Text("\(cur)\(price)")
                .frame(width: 80, alignment: .trailing)
                .bold()
                .foregroundColor(.green)
        }
        .padding(10)
        .frame(width: 100, height: 100)
        .background(Color.green.opacity(0.2))
        .cornerRadius(10)
    }
    
    // display currency
    func currency(finsih: String) -> String {
        switch finsih {
        case "usd", "usd_foil", "usd_etched":
            return "$"
        case "eur", "eur_foil", "eur_etched":
            return "\u{20AC}"
        default:
            return ""
        
        }
    }
    
    // return a gradient based on the finish type
    func gradient(finish: String) -> LinearGradient {
        switch finish.lowercased() {
        case "usd", "eur":
            return LinearGradient(
                colors: [.gray.opacity(0.6), .gray.opacity(0.3), .gray.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "usd_foil", "eur_foil":
            return LinearGradient(
                colors: [.blue, .purple, .pink, .orange, .yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "usd_etched", "eur_etched":
            return LinearGradient(
                colors: [.black, .gray, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [.blue, .blue.opacity(0.6), .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

