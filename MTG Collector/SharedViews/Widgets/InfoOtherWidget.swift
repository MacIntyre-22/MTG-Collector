//
//  InfoOtherWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//  Purpose:
//      Displays misc info given to it

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoOtherWidget: View {
    
    // MARK: Stored Properties

    var releasedAt: String
    var finishes: [String]
    var set: String
    var reserved: Bool
    
    // MARK: View

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Released: \(releasedAt)")
                    HStack {
                        Text("Finishes Available: ")
                        ForEach(finishes, id: \.self) { finish in
                            Text(finish.capitalized)
                                .italic()
                        }
                    }
                    HStack {
                        Text("Set Code:")
                        Text("\(set.uppercased())")
                            .bold()
                    }
                    
                    Text(reserved ? "This card is Reserved" : "This card is not Reserved")
                        .italic()
                }
                Spacer()
            }
            .padding(15)
            .cornerRadius(9)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.background)
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
    }
    }
}

