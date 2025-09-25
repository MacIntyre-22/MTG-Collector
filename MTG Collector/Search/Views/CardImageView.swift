//
//  CardImageView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardImageView: View {
    var imageUrl: String
    
    var body: some View {
        if let url = URL(string: imageUrl) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(minWidth: 180, maxWidth: 250)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 180, maxWidth: 250)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.5), radius: 7, x: 0, y: 3)
                case .failure:
                    Color.gray
                        .frame(minWidth: 180, maxWidth: 250)
                        .cornerRadius(8)
                @unknown default:
                    Color.gray
                        .frame(minWidth: 180, maxWidth: 250)
                        .cornerRadius(8)
                }
            }
        } else {
            Color.gray
                .frame(minWidth: 180, maxWidth: 250)
                .cornerRadius(8)
        }
    }
}
