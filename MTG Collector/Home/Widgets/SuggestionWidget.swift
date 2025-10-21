//
//  SuggestionWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-18.
//

import SwiftUI

struct SuggestionWidget: View {
    
    //
    var systemImage: String
    var title: String
    var description: String
    var collection: [CardJSON]
    
    @State var rotation: Double = 0
    
    // get a shuffle function from parent
    var shuffle: () -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    // title
                    Label(title, systemImage: systemImage)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        
                        // spin button
                        rotation += 360
                        
                        // reshuffle the collection
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

                
                
                // display models
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        // cards preview
                        if collection.count >= 6 {
                            ForEach(0..<6) { i in
                                // take index from collectioin in
                                // dont want to show all the cards
                                
                                // get card data types
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
                        
                        // view all card
                        // todo
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 10)
                
                
                // info and view all
                ZStack {
                    Color(red: 20/255, green: 20/255, blue: 20/255)
                    HStack {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .italic()
                            .lineLimit(1)
                        Spacer()
                        // view all
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

