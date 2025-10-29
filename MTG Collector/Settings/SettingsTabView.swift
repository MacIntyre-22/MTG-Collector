//
//  SettingsTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import SwiftUI

struct SettingsTabView: View {
    
    @Bindable var settings: Settings
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    
                    // color theme
                    ThemePickerWidget(selection: $settings.theme)
                    
                    // app info
                    AppInfoWidget()
                    
                    // delete data
                    DeleteDataWidget()
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("Settings")
            
        }
        
    }
}

