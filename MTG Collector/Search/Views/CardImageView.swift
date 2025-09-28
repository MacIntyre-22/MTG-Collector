//
//  CardImageView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardImageView: View {
    var maxWidth: Double
    var imageUrl: String
    
    var body: some View {
        // set image from passed string url
        if let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                    // 1.4 is the ratio of a magic card
                        .frame(maxWidth: maxWidth, maxHeight: (maxWidth*1.4))
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: maxWidth)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.5), radius: 7, x: 0, y: 3)
                    // All fail cases are just filled with a gray view
                case .failure:
                    Color.gray
                        .frame(maxWidth: maxWidth, maxHeight: (maxWidth*1.4))
                        .cornerRadius(8)
                @unknown default:
                    Color.gray
                        .frame(maxWidth: maxWidth, maxHeight: (maxWidth*1.4))
                        .cornerRadius(8)
                }
            }
        } else {
            Color.gray
                .frame(maxWidth: maxWidth, maxHeight: (maxWidth*1.4))
                .cornerRadius(8)
        }
    }
}
