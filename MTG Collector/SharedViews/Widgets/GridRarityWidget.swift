//
//  GridRarityWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct GridRarityWidget: View {
    var rarity: String
    
    var color: LinearGradient {
        switch(rarity) {
            case "common":
                return common
            case "uncommon":
                return uncommon
            case "rare":
                return rare
            case "mythic":
                return mythic
            default:
                return LinearGradient(colors: [Color.black], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    // colors by rarity
    let common = LinearGradient(
        colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.5), Color.gray.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
     let uncommon = LinearGradient(
        colors: [Color.blue, Color.blue.opacity(0.6), Color.blue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
     let rare = LinearGradient(
        colors: [Color.yellow, Color.orange, Color.yellow],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
     let mythic = LinearGradient(
        colors: [Color.red, Color.orange, Color.red],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var body: some View {
        Text(rarity.capitalized)
            .italic()
            .bold()
            .padding(5)
            .foregroundColor(.white)
            .background(content: {color})
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

