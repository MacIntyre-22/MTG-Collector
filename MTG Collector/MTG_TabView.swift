//
//  MTGTab_View.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-19.
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
    @State private var pro = ProAccessManager()
    
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

    /// Resolved accent colour from the user's theme, with a safe fallback.
    private var tint: Color { Color(hex: settings.theme) ?? .orange }

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
                        Text("My Hold")
                    })
                
                SettingsTabView(settings: settings)
                    .tabItem({
                        Image(systemName: "gearshape")
                        Text("Settings")
                    })
            }
            .tint(tint)

            if settings.onBoarding {
                OnBoardingView() {
                    settings.onBoarding = false
                }
                .ignoresSafeArea()
            }
        }
        .tint(tint)
        .environment(pro)
        .environment(\.appTint, tint)
        .environment(\.appCurrency, settings.appCurrency)
        .onChange(of: pro.isPro) { _, isPro in
            // mirror the verified entitlement into the persisted Settings flag for offline gating
            settings.isPro = isPro
        }
    }
}

