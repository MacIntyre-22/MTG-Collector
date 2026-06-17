//
//  SuggestionWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-18.
//  Purpose:
//      Displays one daily suggestion row: a header with a shuffle control, a horizontal card strip
//      (or a loading skeleton while the row fetches), and a footer with a "Daily Suggestions" tag,
//      the row blurb and a View All link.
//  External types:
//      CardJSON, SFAPI, CardInfoView, CardGridView, SuggestionView

// MARK: Imports

import SwiftUI

// MARK: Types

struct SuggestionWidget: View {

    // MARK: Stored Properties

    var systemImage: String
    var title: String
    var description: String
    var collection: [CardJSON]
    var isLoading: Bool = false
    var shuffle: () -> Void

    // MARK: State Properties

    @Environment(\.appTint) private var tint
    @State var rotation: Double = 0

    // MARK: View

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Label(title, systemImage: systemImage)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Button {
                        rotation += 360
                        shuffle()
                    } label: {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .rotationEffect(.degrees(rotation))
                    }
                    .disabled(isLoading || collection.isEmpty)
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)

                if isLoading && collection.isEmpty {
                    skeletonRow
                } else {
                    cardRow
                }

                footer
            }
            .cornerRadius(9)
            .widgetStyle()
        }
    }

    // MARK: Subviews

    private var cardRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                if collection.count >= 10 {
                    ForEach(0..<10) { i in
                        /// take index from collection — don't show all the cards.
                        /// Lazy so only the visible cards build/decode and load art.
                        let cardModel = SFAPI.JSONtoModel(json: collection[i])

                        NavigationLink(destination: CardInfoView(card: cardModel)) {
                            CardGridView(card: cardModel, showPreviews: true)
                                .frame(width: 180)
                                .widgetStyle(.solid)
                        }
                    }
                }
            }
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 10)
    }

    /// Placeholder card shapes shown while the row's request is in flight.
    private var skeletonRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 180)
                        .aspectRatio(0.714, contentMode: .fit)
                }
            }
            .padding(.vertical, 4)
        }
        .redacted(reason: .placeholder)
        .shimmering()
        .padding(.bottom, 20)
        .padding(.horizontal, 10)
    }

    private var footer: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Label("Daily Suggestions", systemImage: "star.fill")
                    .font(.caption2.bold())
                    .foregroundColor(tint)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .italic()
                    .lineLimit(1)
            }
            Spacer()
            NavigationLink(destination: SuggestionView(systemImage: systemImage, title: title, description: description, collection: collection)) {
                Text("View All")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .pillStyle()
            }
            .disabled(collection.isEmpty)
        }
        .padding()
        .background(Color(.secondarySystemFill))
    }
}
