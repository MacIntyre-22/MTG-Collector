//
//  SuggestionWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-18.
//  Purpose:
//      Displays one daily suggestion row: a header, a horizontal card strip (or a loading skeleton
//      while the row fetches) capped at 8 cards with a trailing "View All" tile, and a footer with a
//      "Daily Suggestions" tag, the row blurb and a View All link.
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

    // MARK: State Properties

    @Environment(\.appTint) private var tint
    @State private var selectedCard: Card?

    // MARK: View

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Label(title, systemImage: systemImage)
                        .font(.title2)
                        .bold()
                    Spacer()
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
            LazyHStack(alignment: .top) {
                // Show the first 8 as a preview — lazy so only visible cards build/decode + load art.
                ForEach(Array(collection.prefix(8).enumerated()), id: \.offset) { _, json in
                    let cardModel = SFAPI.JSONtoModel(json: json)

                    Button {
                        selectedCard = cardModel
                    } label: {
                        CardGridView(card: cardModel, showPreviews: true)
                            .frame(width: 180)
                            .widgetStyle(.solid)
                    }
                    .buttonStyle(.plain)
                }

                // Trailing tile that opens the full list (only once there are cards to show).
                if !collection.isEmpty {
                    viewAllCard
                }
            }
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 10)
        .cardInfoSheet(card: $selectedCard)
    }

    /// A ghost card-shaped tile at the end of the strip that links to the full list.
    private var viewAllCard: some View {
        NavigationLink(destination: SuggestionView(systemImage: systemImage, title: title, description: description, collection: collection)) {
            VStack(spacing: 12) {
                Image(systemName: "rectangle.stack.fill")
                    .font(.system(size: 36))
                Text("View All")
                    .font(.headline)
                Text("\(collection.count) cards")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(tint)
            .frame(width: 160, height: 224)
            .background(RoundedRectangle(cornerRadius: 8).fill(tint.opacity(0.08)))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [7]))
                    .foregroundStyle(tint.opacity(0.45))
            )
            .padding([.horizontal, .top], 10)
        }
        .buttonStyle(.plain)
    }

    /// Placeholder card shapes shown while the row's request is in flight.
    private var skeletonRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 180)
                        .aspectRatio(0.718, contentMode: .fit)
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
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.capsule)
            .tint(tint)
            .disabled(collection.isEmpty)
        }
        .padding()
        // Frosted band that stays distinct from the glass widget body in both light and dark
        // (system fills read too pale, especially in dark mode).
        .background(.regularMaterial)
    }
}
