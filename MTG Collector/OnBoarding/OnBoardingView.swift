//
//  OnBoardingView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-29.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss
    var toggleOnBoarding: () -> Void
    
    var pages: [PageInfo] = [
        
        PageInfo(title: "Discover", image: "sparkle", text: "Discover new cards based on different categories in the Home tab"),
        PageInfo(title: "Search", image: "magnifyingglass", text: "Search any card by their name and filter your search in the Search tab"),
        PageInfo(title: "Collect", image: "square.stack", text: "Keep track of your collection with Binders and Decks in the Collection tab"),
    ]
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<3) { index in
                    VStack(spacing: 30) {
                        Spacer()
                        // on boarding page
                        OnBoardPageView(pageInfo: pages[index])
                        
                        //
                        Button(action: {
                            if currentPage < 2 {
                                currentPage += 1
                            } else {
                                toggleOnBoarding()
                            }
                        }) {
                            Text(currentPage == 2 ? "Get Started" : "Next")
                                .frame(maxWidth: 100)
                                .fontWeight(.semibold)
                                .padding(10)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: currentPage)
            
            
            
        }
        .background(.background)
    }
}

struct PageInfo {
    var title: String
    var image: String
    var text: String
}

