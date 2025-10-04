//
//  SetIconWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-03.
//

import SwiftUI

struct SetIconWidget: View {
    var set: String
    var rarity: String
    var maxWidth: Double
    
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
        // set
        ZStack {
            
            if !set.isEmpty {
                Image(set)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundColor(.white)
                    .padding(5)
                    .shadow(radius: 4)
            } else {
                Image("MtgBinder")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .padding(5)
                    .shadow(radius: 4)
                    
            }
        }
        .frame(width: maxWidth, height: maxWidth)
        .background(color)
        .cornerRadius(10)
        .foregroundColor(.primary)
        
    }
}
