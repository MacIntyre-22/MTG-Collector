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
    
    var cur: String {
        currency(finsih: finish)
    }
    
    var body: some View {
        Text("\(cur)\(price)")
            .bold()
            .padding(5)
            .foregroundColor(.green)
            .background(content: {Color.green.opacity(0.2)})
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    func currency(finsih: String) -> String {
        switch finsih {
        case "usd", "usd_foil", "usd_etched":
            return "$"
        case "eur", "eur_foil", "eur_etched":
            return "\u{20AC}"
        case "tix":
            return "TIX"
        default:
            return ""
        
        }
    }
}

