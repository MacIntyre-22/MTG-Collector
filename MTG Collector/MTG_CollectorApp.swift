//
//  MTG_CollectorApp.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-19.
//

import SwiftUI
import SwiftData

@main
struct MTG_CollectorApp: App {
    
    var body: some Scene {
        WindowGroup {
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
                
                SettingsTabView()
                    .tabItem({
                        Image(systemName: "gearshape")
                        Text("Settings")
                    })
            }
            
        }
        .modelContainer(for: [Binder.self, Deck.self, SetInfo.self, Card.self, CardEntry.self])
    }
}
