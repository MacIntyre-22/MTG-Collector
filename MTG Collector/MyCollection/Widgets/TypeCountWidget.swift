//
//  TypeCountWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-11.
//

import SwiftUI

struct TypeCountWidget: View {
    var cardTypeCount: [String: Int]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text("Card Types")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 15)
                ForEach(Array(cardTypeCount), id: \.key) { type, value in
                    HStack {
                        Text(type)
                            .foregroundColor(.gray)
                            .italic()
                        Spacer()
                        Text("\(value)")
                            .bold()
                    }
                    .padding(10)
                }
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.18), radius: 15, x: 0, y: 0)
            )
        }
    }
}

