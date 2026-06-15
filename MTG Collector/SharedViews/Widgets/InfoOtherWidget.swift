//
//  InfoOtherWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays misc card metadata: set, artist, collector number, EDHREC rank, release date,
//      finishes, reserved status.

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoOtherWidget: View {

    // MARK: Stored Properties

    var releasedAt: String
    var finishes: [String]
    var set: String
    var setName: String = ""
    var artist: String = ""
    var collectorNumber: String = ""
    var edhrecRank: Int = 0
    var reserved: Bool

    // MARK: View

    var body: some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    // Set: full name + code
                    HStack {
                        Text("Set:")
                        Text(setName.isEmpty ? set.uppercased() : "\(setName) (\(set.uppercased()))")
                            .bold()
                    }

                    if !collectorNumber.isEmpty {
                        Text("Collector #: \(collectorNumber)")
                    }

                    if !artist.isEmpty {
                        Text("Illustrated by \(artist)")
                            .italic()
                    }

                    if edhrecRank > 0 {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.accentColor)
                            Text("EDHREC Rank: #\(edhrecRank)")
                        }
                    }

                    Text("Released: \(releasedAt)")

                    HStack {
                        Text("Finishes Available: ")
                        ForEach(finishes, id: \.self) { finish in
                            Text(finish.capitalized)
                                .italic()
                        }
                    }

                    Text(reserved ? "This card is Reserved" : "This card is not Reserved")
                        .italic()
                }
                Spacer()
            }
            .padding(15)
            .cornerRadius(9)
            .widgetStyle()
        }
    }
}
