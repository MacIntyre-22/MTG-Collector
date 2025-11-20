//
//  AppInfoWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//  Purpose:
//      Hard coded app info to display for the user

// MARK: Imports

import SwiftUI

// MARK: Types

struct AppInfoWidget: View {
    
    // MARK: Stored Properties

    var webURI: URL = URL(string: "https://benmacintyre.net")!
    
    var info: String = """
    This app is an independent school project and is not affiliated with Wizards of the Coast in any way. All Magic: The Gathering content (card names, images, related marks, and fonts) belong to Wizards of the Coast LLC. 
    
    Card data and images are provided by the Scryfall API (https://scryfall.com), used under their API terms of service. This app does not claim ownership of any game content and is for personal use only.
    """
    
    // MARK: State Properties

    @State var sheetIsShowing: Bool = false
    
    // MARK: View

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Label("Information", systemImage: "info.circle")
                    .font(.title2)
                    .bold()
                Text(info)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Developed by ")
                        .foregroundColor(.gray)
                    Button {
                        sheetIsShowing.toggle()
                    } label: {
                        Text("benmacintyre.net")
                            .italic()
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .frame(maxWidth: 600)
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
        }
        .sheet(isPresented: $sheetIsShowing) {
            WebSheet(url: webURI)
                .presentationDragIndicator(.visible)
        }
    }
}

