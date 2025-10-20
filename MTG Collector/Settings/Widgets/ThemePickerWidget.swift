//
//  ThemePickerWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//

import SwiftUI

struct ThemePickerWidget: View {
    
    // get current theme
    @Binding var selection: String
    // preset themes
    var allThemes: [String] = ["Orange Theme", "Blue Theme", "Green Theme", "Red Theme"]
    
    var body: some View {
        // color theme
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
                    .shadow(color: .gray.opacity(0.25), radius: 15, x: 0, y: 0)
            )
        }
    }
}

