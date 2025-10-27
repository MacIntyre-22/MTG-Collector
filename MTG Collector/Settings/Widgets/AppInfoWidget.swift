//
//  AppInfoWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//

import SwiftUI

struct AppInfoWidget: View {
    var body: some View {
        // app info
        ZStack {
            VStack(alignment: .leading) {
                Label("Information", systemImage: "info.circle")
                    .font(.title2)
                    .bold()
                Text("description text lorem")
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
    }
}

