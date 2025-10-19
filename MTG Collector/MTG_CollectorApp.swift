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
            MTG_TabView()
        }
        .modelContainer(for: [Binder.self, Deck.self, SetInfo.self, Card.self, CardEntry.self, Settings.self])
    }
}
