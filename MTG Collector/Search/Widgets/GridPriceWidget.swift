//
//  GridPriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct GridPriceWidget: View {
    var finish: String
    var price: String
    
    var body: some View {
        Text("$\(price)")
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .background(priceGradient(finish: finish).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    // return a gradient based on the finish type
    func priceGradient(finish: String) -> LinearGradient {
        switch finish {
        case "Base":
            return LinearGradient(
                colors: [.gray.opacity(0.6), .gray.opacity(0.3), .gray.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Foil":
            return LinearGradient(
                colors: [.blue, .purple, .pink, .orange, .yellow],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "Etched":
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

