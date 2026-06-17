//
//  HeaderWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-23.
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
    var stats: CollectionStats?
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
                    PricePill(stats: stats)
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
                    PricePill(stats: stats)
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
