//
//  MTG_CollectorApp.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-19.
//  Purpose:
//      Top level app struct
//  External Types:
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

@main
struct MTG_CollectorApp: App {
    
    // MARK: View

    var body: some Scene {
        WindowGroup {
            MTG_TabView()
        }
        .modelContainer(for: [Binder.self, Deck.self, SetInfo.self, Card.self, CardEntry.self, Settings.self])
    }
}
