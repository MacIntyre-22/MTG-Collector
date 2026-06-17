//
//  HomeTabView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
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
    @State var homeSuggestions: HomeSuggestions = HomeSuggestions()
    /// Bumped by the Settings dev "Reload Home" option to force a refetch without relaunching.
    @AppStorage("homeReloadToken") private var reloadToken = 0
    
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
                        
                        Text("Cardhold")
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
        // Runs on appear and whenever the dev reload token changes.
        .task(id: reloadToken) {
            await loadSuggestions()
            await loadSetsIfNeeded()
        }
    }

    // MARK: Loading

    /// Suggestions are a once-per-day discovery: reuse today's cached set if present, otherwise
    /// fetch all six rows concurrently and persist them with today's date stamp.
    private func loadSuggestions() async {
        if HomeSuggestionsStore.isFreshForToday(),
           let cached = await Task.detached(priority: .userInitiated, operation: {
               HomeSuggestionsStore.load()
           }).value {
            homeSuggestions = cached
            return
        }

        // Fire all six searches concurrently instead of one-after-another, so the whole row set
        // arrives in roughly the time of the slowest request, not their sum.
        async let new       = SFAPI.fetchCardQuery(query: "(is:rare+or+is:mythic)+game:paper+-t:token&order=released&dir=desc")
        async let popular   = SFAPI.fetchCardQuery(query: "game:paper+-t:land+-t:token&order=edhrec&dir=asc")
        async let fullArt   = SFAPI.fetchCardQuery(query: "(is:fullart+or+is:borderless+or+is:showcase)+game:paper&order=released&dir=desc")
        async let oldSchool = SFAPI.fetchCardQuery(query: "frame:1997+or+frame:1993&order=released&dir=asc")
        async let expensive = SFAPI.fetchCardQuery(query: "(is:mythic+or+is:promo)+game:paper&order=usd&dir=desc")
        async let budget    = SFAPI.fetchCardQuery(query: "usd<=5+order:edhrec&dir=asc")

        var fresh = HomeSuggestions()
        fresh.newCards     = await new
        fresh.popularCards = await popular
        fresh.fullArt      = await fullArt
        fresh.oldSchool    = await oldSchool
        fresh.expensive    = await expensive
        fresh.budget       = await budget
        homeSuggestions = fresh

        // Persist off the main thread — encoding ~1k cards shouldn't block the UI.
        Task.detached(priority: .utility) { HomeSuggestionsStore.save(fresh) }
    }

    /// Set list is reference data that rarely changes — only fetch when we have none, and de-dupe
    /// against a Set (O(n)) instead of a per-row linear scan (O(n²)).
    private func loadSetsIfNeeded() async {
        guard setList.isEmpty else { return }
        let existing = Set(setList.map(\.code))
        for set in await SFAPI.fetchSetData() {
            let model = SFAPI.setToModel(json: set)
            if !existing.contains(model.code) {
                modelContext.insert(model)
            }
        }
    }
}

