//
//  InfoOtherWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-28.
//  Purpose:
//      Displays catalogue / printing info: set, artist, collector number, EDHREC rank,
//      release date, finishes and reserved-list status.

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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                row("Set", value: setName.isEmpty ? set.uppercased() : "\(setName) (\(set.uppercased()))")

                if !collectorNumber.isEmpty {
                    row("Collector №", value: collectorNumber)
                }
                if !artist.isEmpty {
                    row("Artist", value: artist)
                }
                if edhrecRank > 0 {
                    row("EDHREC Rank", value: "#\(edhrecRank)")
                }

                row("Released", value: releasedAt)

                if !finishes.isEmpty {
                    HStack {
                        Text("Finishes").foregroundStyle(.secondary)
                        Text(finishes.map { $0.capitalized }.joined(separator: ", "))
                            .italic()
                    }
                }

                Text(reserved ? "On the Reserved List" : "Not on the Reserved List")
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
            Spacer()
        }
        .padding(15)
        .cornerRadius(9)
        .widgetStyle()
    }

    // MARK: Subviews

    private func row(_ label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(label).foregroundStyle(.secondary)
            Text(value).bold()
        }
    }
}
