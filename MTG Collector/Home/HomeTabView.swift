//
//  HomeTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//  Purpose:
//      The Home page for my app that displays multiple widgets with suggested cards pulled from the api
//  External Types:
//      SetInfo, HomeSuggestions, SuggestionWidget, SFAPI, SetJSON, SetInfo

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct HomeTabView: View {
    
    // MARK: State Properties
    
    @Environment(\.modelContext) var modelContext
    @Query var setList: [SetInfo]
    @State var isLoaded: Bool = false
    @State var homeSuggestions: HomeSuggestions = HomeSuggestions()
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        Image("MtgBinder")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                        
                        Text("MTG Collector")
                            .font(.title)
                            .bold()
                    }
                    .foregroundColor(.primary)
                }
                .padding(.vertical, 20)
                
                VStack(spacing: 30) {
                    
                    SuggestionWidget(systemImage: "sparkles", title: "New", description: "Recently released cards", collection: homeSuggestions.newCards) {homeSuggestions.newCards = homeSuggestions.newCards.shuffled()}
                    
                    SuggestionWidget(systemImage: "chart.line.uptrend.xyaxis", title: "Popular", description: "Popular cards based on their ranking", collection: homeSuggestions.popularCards) {homeSuggestions.popularCards = homeSuggestions.popularCards.shuffled()}
                    
                    SuggestionWidget(systemImage: "crown", title: "Pricey", description: "Some of the most expensive cards", collection: homeSuggestions.expensive) {homeSuggestions.expensive = homeSuggestions.expensive.shuffled()}
                    
                    SuggestionWidget(systemImage: "dollarsign", title: "Budget", description: "Cards under $5", collection: homeSuggestions.budget) {homeSuggestions.budget = homeSuggestions.budget.shuffled()}
                    
                    SuggestionWidget(systemImage: "paintbrush.pointed", title: "Full Art", description: "Full art and borderless cards", collection: homeSuggestions.fullArt) {homeSuggestions.fullArt = homeSuggestions.fullArt.shuffled()}
                    
                    SuggestionWidget(systemImage: "hourglass", title: "Old School", description: "Classic cards with 93 and 97 border", collection: homeSuggestions.oldSchool) {homeSuggestions.oldSchool = homeSuggestions.oldSchool.shuffled()}
                }
                .padding(.horizontal, 10)
            }
        }
        .task {
            /// grab set data and home suggestion cards
            /// load once
            if !isLoaded {
                
                homeSuggestions.newCards = await SFAPI.fetchCardQuery(query: "(is:rare+or+is:mythic)+game:paper+-t:token&order=released&dir=desc")
                homeSuggestions.popularCards = await SFAPI.fetchCardQuery(query: "game:paper+-t:land+-t:token&order=edhrec&dir=asc")
                homeSuggestions.fullArt = await SFAPI.fetchCardQuery(query: "(is:fullart+or+is:borderless+or+is:showcase)+game:paper&order=released&dir=desc")
                homeSuggestions.oldSchool = await SFAPI.fetchCardQuery(query: "frame:1997+or+frame:1993&order=released&dir=asc")
                homeSuggestions.expensive = await SFAPI.fetchCardQuery(query: "(is:mythic+or+is:promo)+game:paper&order=usd&dir=desc")
                homeSuggestions.budget = await SFAPI.fetchCardQuery(query: "usd<=5+order:edhrec&dir=asc")
                
                let tempSets: [SetJSON] = await SFAPI.fetchSetData()
                for set in tempSets {
                    
                    let tempSet: SetInfo = SFAPI.setToModel(json: set)
                    if !setList.contains(where: { $0.code == tempSet.code }) {
                        modelContext.insert(tempSet)
                    }
                }
                isLoaded.toggle()
            }
        }
    }
}

