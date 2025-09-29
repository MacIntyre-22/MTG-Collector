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
    @State var showFullScreen: Bool = false
    
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
                    // if success, display the image with a long press gesture
                    // this shows a full screen versioin of the card
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: maxWidth)
                        .cornerRadius(8)
                        .onLongPressGesture {
                            showFullScreen = true
                        }
                        .fullScreenCover(isPresented: $showFullScreen) {
                            ZStack {
                                Color.gray.opacity(0.3).ignoresSafeArea()
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .cornerRadius(17)
                                        .padding()
                                        
                                } placeholder: {
                                    ProgressView()
                                }

                                VStack {
                                    HStack {
                                        Spacer()
                                        Button(action: { showFullScreen = false }) {
                                            Image(systemName: "xmark")
                                                .font(.largeTitle)
                                                .padding()
                                        }
                                    }
                                    Spacer()
                                }
                            }
                            
                        }
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
