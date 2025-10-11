//
//  CardImageView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import SwiftUI

struct CardImageView: View {
    var maxWidth: Double
    var imageURIs: ImageURIs
    
    // grab preferred url and if not check the next
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
            
            // default card is magic back
            return "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/513b7bfa-42c9-4d08-ad6c-8e5d478c42d3/dalfpib-83f22b02-5802-40b4-901b-3eecf0ca2058.png/v1/fit/w_828,h_1182,q_70,strp/unofficial_magic_the_gathering_six_color_card_back_by_lordnyriox_dalfpib-414w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTQ2MyIsInBhdGgiOiIvZi81MTNiN2JmYS00MmM5LTRkMDgtYWQ2Yy04ZTVkNDc4YzQyZDMvZGFsZnBpYi04M2YyMmIwMi01ODAyLTQwYjQtOTAxYi0zZWVjZjBjYTIwNTgucG5nIiwid2lkdGgiOiI8PTEwMjQifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.E6ain-taz3WAOjHlySF768nq0Id5NkQMRzOrm95OGXY"
        }
    }
    
    @State var showFullScreen: Bool = false
    
    var body: some View {
        
        ZStack {
            // fallack color
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .cornerRadius(8)
            
            // set image from passed string url
            if let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()

                    case .success(let image):
                        // if success, display the image with a long press gesture
                        // this shows a full screen versioin of the card
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
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(17)
                                            .padding()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Text("Tap to Exit")
                                                .italic()
                                                .bold()
                                                .foregroundColor(.accent)
                                        }
                                        Spacer()
                                    }
                                    .padding(50)
                                }
                                .onTapGesture(count: 1, perform: {
                                    showFullScreen = false
                                })
                                
                            }
                        // All fail cases are just filled with a gray view
                    case .failure:
                        // return empty view because of fall back color
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        // use max width but lock to aspect ratio
        // better than puttping max height a million times
        .aspectRatio(0.714, contentMode: .fit)
        .frame(maxWidth: maxWidth)
    }
}
