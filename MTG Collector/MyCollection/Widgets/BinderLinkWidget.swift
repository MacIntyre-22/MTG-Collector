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
    
    var body: some View {
        HStack {
            if let image =  ImageManager.fetchImage(withIdentifier: binder.id){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
            } else {
                Image("MtgBinder")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.primary)
            }
            VStack(alignment: .leading) {
                Spacer()
                Text(binder.name)
                Divider()
                
                
                HStack {
                    Text(binder.totalPrice, format: .currency(code: "CAD"))
                        .padding(5)
                        .foregroundColor(.green)
                        .background(Color.green.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Image(systemName: "square.stack")
                        .foregroundColor(.primary)
                    Text("\(binder.cardCount)")
                }
                Spacer()
            }
            .padding(10)
        }
    }
}

