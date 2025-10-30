//
//  OnBoardPageView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-30.
//

import SwiftUI

struct OnBoardPageView: View {
    
    var pageInfo: PageInfo
    
    var body: some View {
        VStack (alignment: .center, spacing: 20){
            Image(systemName: pageInfo.image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.primary)
                
            Text(pageInfo.title)
                .bold()
                .font(.title)
                .foregroundColor(.primary)
            Text(pageInfo.text)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(30)
    }
}

