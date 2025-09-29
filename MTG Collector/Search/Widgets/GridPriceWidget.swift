//
//  GridPriceWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct GridPriceWidget: View {
    var price: String
    
    var body: some View {
        Text("$\(price)")
            .bold()
            .padding(5)
            .foregroundColor(.green)
            .background(content: {Color.green.opacity(0.2)})
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

