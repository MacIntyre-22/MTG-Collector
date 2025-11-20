//
//  HeaderWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-23.
//  Purpose:
//      Displays deck information link name, price, and image

// MARK: Imports

import SwiftUI

// MARK: Types

struct HeaderWidget: View {
    
    // MARK: Stored Properties
    
    var showCover: Bool
    var coverImage: UIImage
    var name: String
    var price: Double
    var count: Int
    
    // MARK: View

    var body: some View {
        if showCover {
            VStack {
                ZStack(alignment: .center) {
                    Color.gray
                        .frame(width: 250, height: 250)
                        .cornerRadius(10)
                    Image(uiImage: coverImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .cornerRadius(10)
                }
                .shadow(color: .gray.opacity(0.18), radius: 15, x: 0, y: 0)
                .padding()
                
                Text(name)
                    .font(.title)
                    .bold()
                
                HStack {
                    Text(price, format: .currency(code: "CAD"))
                        .padding(5)
                        .foregroundColor(.green)
                        .background(Color.green.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Image(systemName: "square.stack")
                        .foregroundColor(.primary)
                    Text("\(count)")
                }
                
                Divider()
                
            }
            .padding()
        } else {
            VStack {
                HStack {
                    Text(name)
                        .font(.title)
                        .bold()
                        
                    Spacer()
                }
                
                HStack {
                    Text(price, format: .currency(code: "CAD"))
                        .padding(5)
                        .foregroundColor(.green)
                        .background(Color.green.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Image(systemName: "square.stack")
                        .foregroundColor(.primary)
                    Text("\(count)")
                    Spacer()
                    
                }
                .padding(.bottom)
            }
            .padding(.leading, 20)
        }
    }
}
