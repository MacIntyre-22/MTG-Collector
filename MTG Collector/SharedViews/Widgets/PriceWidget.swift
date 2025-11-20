//
//  PriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-29.
//  Purpose:
//      Displays a pricewidget with given finish and price
//  External Types:
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct PriceWidget: View {
    
    // MARK: Stored Properties

    var finish: String
    var price: String
    
    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            Text(finish.capitalized)
                .bold()
                .italic()
                .foregroundColor(.white)
                .padding(5)
                .background(priceGradient(finish: finish))
                .cornerRadius(5)
            
            Spacer()
            
            Text("$\(price)")
                .frame(width: 80, alignment: .trailing)
                .bold()
                .foregroundColor(.green)
        }
        .padding(10)
        .frame(width: 100, height: 100)
        .background(Color.green.opacity(0.2))
        .cornerRadius(10)
    }
    
    // MARK: priceGradient
    
    /// return a gradient based on the finish type
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

