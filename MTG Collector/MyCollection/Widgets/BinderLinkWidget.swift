//
//  BinderLinkWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI
import SwiftData

struct BinderLinkWidget: View {
    var binder: Binder
    
    var coverImage: String {
        if !binder.coverImage.isEmpty {
            return binder.coverImage
        } else {
            return "MtgBinder"
        }
    }
    
    var body: some View {
        HStack {
            Image("MtgBinder")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 75, height: 75)
                .foregroundColor(.black)
            VStack(alignment: .leading) {
                Text(binder.name)
                Divider()
                
                
                HStack {
                    Text("$ \(binder.totalPrice, specifier: "%.2f")")
                        .padding(5)
                        .foregroundColor(.green)
                        .background(Color.green.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Image(systemName: "square.stack")
                        .foregroundColor(.black)
                    Text("\(binder.cardCount)")
                }
                Spacer()
            }
            .padding(10)
        }
    }
}

