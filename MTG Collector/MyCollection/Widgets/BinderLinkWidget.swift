//
//  BinderLinkWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//      Used as a list item view to link to the respective deck
//  External Types:
//      Binder, ImageManger

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct BinderLinkWidget: View {
    
    // MARK: Stored Properties
    
    var binder: Binder
    
    // MARK: View
    
    var body: some View {
        ZStack {
            HStack {
                ZStack(alignment: .topLeading) {
                    if let image =  ImageManager.fetchImage(withIdentifier: binder.id){
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    } else {
                        Color.gray
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Image("MtgBinder")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading) {
                        Button {
                            // set pinned
                            binder.pinned.toggle()
                        } label: {
                            Image(systemName: binder.pinned ? "pin.fill"
                                  : "pin")
                            .resizable()
                            .frame(width: 15, height: 20)
                            .shadow(radius: 10)
                        }
                        .padding(5)
                    }
                }
                
                VStack(alignment: .leading) {
                    Spacer()
                    Text(binder.name)
                        .foregroundColor(.primary)
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
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                .padding(.leading, 10)
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
}

