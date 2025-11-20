//
//  SettingsTabView.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//  Purpose:
//      Displays the widgets for the settings
//  External Types:
//      ThemePickerWidget, AppInfoWidget, DeleteDataWidget

// MARK: Imports

import SwiftUI

// MARK: Types

struct SettingsTabView: View {
    
    // MARK: State Properties

    @Bindable var settings: Settings
    
    // MARK: View

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ThemePickerWidget(selection: $settings.theme)
                    AppInfoWidget()
                    DeleteDataWidget()
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("Settings")
        }
    }
}

