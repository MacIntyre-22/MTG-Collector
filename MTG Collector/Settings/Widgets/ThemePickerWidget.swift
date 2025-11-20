//
//  ThemePickerWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//  Purpose:
//      Allows the user to select the tint color of the app

// MARK: Imports

import SwiftUI

// MARK: Types

struct ThemePickerWidget: View {
    
    // MARK: Stored Properties

    var allThemes: [String] = ["Orange Theme", "Blue Theme", "Green Theme", "Red Theme"]
    
    // MARK: State Properties
    
    @Binding var selection: String
    
    // MARK: View
    
    var body: some View {
        ZStack {
            HStack {
                Text("Theme")
                    .padding(10)
                Spacer()
                Picker("Color Theme", selection: $selection) {
                    ForEach(allThemes, id: \.self) { theme in
                        Text(theme)
                    }
                }
                .pickerStyle(.menu)
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 45)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
}

