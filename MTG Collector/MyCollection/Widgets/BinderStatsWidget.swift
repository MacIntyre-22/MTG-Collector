//
//  BinderStatsWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-03.
//

import SwiftUI

struct BinderStatsWidget: View {
    var binder: Binder
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Card Count: \(binder.cardCount)")
            Text("Unique Cards: \(binder.uniqueCardCount)")
            Text("Total Price: \(binder.totalPrice)")
            Text("Most Expensive Card: \(binder.highestPricedCard?.card.name ?? "No Card")")
            
            Text("Rarities:")
                .bold()
            ForEach(Array(binder.rarities.keys), id: \.self) { key in
                if let value = binder.rarities[key] {
                    HStack {
                        GridRarityWidget(rarity: key)
                            .padding(.top, 5)
                        Text(": \(value)")
                            .font(.custom("", size: 20))
                    }
                }
            }
            
            Text("Mana Types:")
                .bold()
            ForEach(Array(binder.manaTypeCount.keys), id: \.self) { key in
                if let value = binder.manaTypeCount[key] {
                    HStack {
                        Image(key)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(": \(value)")
                            .font(.custom("", size: 20))

                    }
                }
            }
            
            Text("Creature Types:")
                .bold()
            ForEach(Array(binder.cardTypeCount.keys), id: \.self) { key in
                if let value = binder.cardTypeCount[key] {
                    Text("\(key): \(value)")
                }
            }
        }
    }
}

