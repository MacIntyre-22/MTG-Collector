//
//  MTGTab_View.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//  Purpose:
//      Contains all the tabs for the app, also controls the settings and onboarding
//  External Types:
//      Settings, HomeTabView, SearchTabView, MyCollectionTabView, SettingsTabView, OnBoardingView

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct MTG_TabView: View {
    
    // MARK: State Properties
    
    @Environment(\.modelContext) var modelContext
    @Query var settingsQuery: [Settings]
    
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
            TabView {
                HomeTabView()
                    .tabItem({
                        Label("Home", systemImage: "house")
                    })
                SearchTabView()
                    .tabItem({
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    })
                
                MyCollectionTabView()
                    .tabItem({
                        Image("MtgBinderIcon")
                            .renderingMode(.template)
                            .scaledToFit()
                        Text("My Collection")
                    })
                
                SettingsTabView(settings: settings)
                    .tabItem({
                        Image(systemName: "gearshape")
                        Text("Settings")
                    })
            }
            .tint(Color(settings.theme))
            
            if settings.onBoarding {
                OnBoardingView() {
                    settings.onBoarding = false
                }
                .ignoresSafeArea()
            }
        }
        
    }
}

