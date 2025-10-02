//
//  InfoOtherWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-28.
//

import SwiftUI

struct InfoOtherWidget: View {
    var releasedAt: String
    var finishes: [String]
    var set: String
    var reserved: Bool
    
    var body: some View {
        Text("Released: \(releasedAt)")
        HStack {
            Text("Finishes: ")
            ForEach(finishes, id: \.self) { finish in
                Text(finish.capitalized)
            }
        }
        Text("Set Code: \(set)")
        Text(reserved ? "This card is being printed" : "This card is not being printed")
    }
}

