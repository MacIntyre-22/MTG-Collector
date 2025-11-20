//
//  SuggestionWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-18.
//  Purpose:
//      Displays an array of cards based on hard coded filters
//  External types:
//      CardJSON, SFAPI, CardInfoView, CardGridView, SuggestionView

// MARK: Imports

import SwiftUI

// MARK: Types

struct SuggestionWidget: View {
    
    // MARK: Stored Properties
    
    var systemImage: String
    var title: String
    var description: String
    var collection: [CardJSON]
    var shuffle: () -> Void
    
    // MARK: State Properties
    
    @State var rotation: Double = 0
    
    // MARK: View
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Label(title, systemImage: systemImage)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        rotation += 360
                        shuffle()
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .rotationEffect(.degrees(rotation))
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        if collection.count >= 10 {
                            ForEach(0..<10) { i in
                                /// take index from collectioin in
                                /// dont want to show all the cards
                                let cardJson = collection[i]
                                let cardModel = SFAPI.JSONtoModel(json: cardJson)
                                
                                NavigationLink(destination: CardInfoView(card: cardModel)) {
                                    CardGridView(card: cardModel, showPreviews: true)
                                        .frame(width: 180)
                                        .background(content: {Color.gray.opacity(0.18)})
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 10)
                
                ZStack {
                    Color(red: 20/255, green: 20/255, blue: 20/255)
                    HStack {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .italic()
                            .lineLimit(1)
                        Spacer()
                        NavigationLink(destination: SuggestionView(systemImage: systemImage, title: title, description: description, collection: collection)) {
                            Text("View All")
                                .foregroundColor(.white)
                                .padding(5)
                                .frame(maxWidth: 100, maxHeight: 30)
                                .background(Color.accentColor)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                }
            }
            .cornerRadius(9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 15, x: 0, y: 0)
            )
        }
    }
}

