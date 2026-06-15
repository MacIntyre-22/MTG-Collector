//
//  MTGTab_View.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-10-19.
//  Purpose:
//      Contains all the tabs for the app, also controls the settings and onboarding
//  External Types:
//      Settings, HomeTabView, SearchTabView, MyCollectionTabView, SettingsTabView, OnBoardingView

// MARK: Imports

import SwiftUI
import SwiftData
import CoreSpotlight

// MARK: Types

struct MTG_TabView: View {

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    @Query var settingsQuery: [Settings]
    @StateObject private var spotlightRouter = SpotlightRouter()
    @State private var selectedTab: Int = 0
    
    // MARK: Computed Properties
    
    var settings: Settings {
            /// grab the first settings item so it is always the same
            if let existing = settingsQuery.first {
                return existing
            } else {
                /// if it doesn't exists (On first app launch)
                /// create an instance
                ///
                let newSettings = Settings()
                modelContext.insert(newSettings)
                return newSettings
            }
        }
    
    // MARK: View

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                HomeTabView()
                    .tag(0)
                    .tabItem({
                        Label("Home", systemImage: "house")
                    })
                SearchTabView()
                    .tag(1)
                    .tabItem({
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    })

                MyCollectionTabView()
                    .tag(2)
                    .tabItem({
                        Image("MtgBinderIcon")
                            .renderingMode(.template)
                            .scaledToFit()
                        Text("My Collection")
                    })

                SettingsTabView(settings: settings)
                    .tag(3)
                    .tabItem({
                        Image(systemName: "gearshape")
                        Text("Settings")
                    })
            }
            .tint(Color(settings.theme))
            .environmentObject(spotlightRouter)
            .onContinueUserActivity(CSSearchableItemActionType) { activity in
                if let id = Spotlight.identifier(from: activity) {
                    spotlightRouter.openID = id
                    // jump to My Collection; pushing the exact item is wired in Phase 4 nav rework
                    selectedTab = 2
                }
            }
            
            if settings.onBoarding {
                OnBoardingView() {
                    settings.onBoarding = false
                }
                .ignoresSafeArea()
            }
        }
        
    }
}

