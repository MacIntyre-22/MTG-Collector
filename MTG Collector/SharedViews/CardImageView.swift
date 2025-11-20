//
//  CardImageView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//      Dsiplays the cards image and allows for a zoomed in view
//  External Types:
//      ImageURIs

// MARK: Imports

import SwiftUI

// MARK: Types

struct CardImageView: View {
    
    // MARK: Stored Properties

    var maxWidth: Double
    var name: String
    var imageURIs: ImageURIs
    var imageUrl: String {
        if !imageURIs.png.isEmpty {
            return imageURIs.png
        } else if !imageURIs.large.isEmpty {
            return imageURIs.large
        } else if !imageURIs.normal.isEmpty {
            return imageURIs.normal
        } else if !imageURIs.small.isEmpty {
            return imageURIs.small
        } else {
            return ""
        }
    }
    
    // MARK: State Properties

    @State var showFullScreen: Bool = false
    
    // MARK: View

    var body: some View {
        
        ZStack {
            /// fallack display
            /// show name on gray background
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            Text(name)
                .bold()
                .padding(10)
            
            if let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()

                    case .success(let image):
                        /// if success, display the image with a long press gesture
                        /// this shows a full screen versioin of the card
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(8)
                            .onLongPressGesture {
                                showFullScreen = true
                            }
                            .fullScreenCover(isPresented: $showFullScreen) {
                                ZStack() {
                                    Color.gray.opacity(0.3).ignoresSafeArea()
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(17)
                                        .padding()
                                        .frame(maxWidth: 600)
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text("Tap to Exit")
                                                .italic()
                                                .bold()
                                                .foregroundColor(.primary)
                                        }
                                        Spacer()
                                    }
                                    .padding(50)
                                }
                                .onTapGesture(count: 1, perform: {
                                    showFullScreen = false
                                })
                                
                            }
                        /// All fail cases are just filled with a gray view
                    case .failure:
                        /// return empty view because of fall back color
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        /// use max width but lock to aspect ratio
        /// better than puttping max height a million times
        .aspectRatio(0.714, contentMode: .fit)
        .frame(maxWidth: maxWidth)
    }
}
