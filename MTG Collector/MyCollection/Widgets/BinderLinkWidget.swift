//
//  BinderLinkWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
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
                            binder.pinned.toggle()
                            HapticManager.medium()
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
                        PricePill(stats: binder.stats)
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
            .widgetStyle()
        }
    }
}

