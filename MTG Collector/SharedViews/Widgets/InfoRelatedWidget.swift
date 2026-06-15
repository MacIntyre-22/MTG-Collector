//
//  InfoRelatedWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-10-02.
//  Purpose:
//      Displays related cards (tokens, combo pieces, meld halves) with their relationship role.
//  External Types:
//      RelatedCardObject, Card, CardInfoView, CardGridView, SFAPI

// MARK: Imports

import SwiftUI

// MARK: Types

struct InfoRelatedWidget: View {

    // MARK: Stored Properties

    var cardParts: [RelatedCardObject]

    // MARK: State Properties

    @State private var related: [RelatedEntry] = []
    @State private var isLoaded = false

    // helper pairing the relationship role with the resolved card
    struct RelatedEntry: Identifiable {
        let id = UUID()
        let component: String
        let card: Card
    }

    // MARK: View

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(related) { entry in
                        VStack(spacing: 4) {
                            NavigationLink(destination: CardInfoView(card: entry.card)) {
                                CardGridView(card: entry.card, showPreviews: true, isFoil: false)
                                    .frame(maxWidth: 180)
                                    .background(Color.gray.opacity(0.18))
                                    .cornerRadius(10)
                            }
                            if !entry.component.isEmpty {
                                Text(roleLabel(entry.component))
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
            /// only run once
            .task {
                if !isLoaded {
                    await getCardParts()
                    isLoaded = true
                }
            }
            .padding(15)
            .cornerRadius(9)
            .widgetStyle()
        }
    }

    // MARK: Helpers

    /// "combo_piece" -> "Combo Piece"
    private func roleLabel(_ component: String) -> String {
        component
            .replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }

    /// fetch each related card object via the api
    func getCardParts() async {
        for part in cardParts {
            if let jsonPart = await SFAPI.fetchCardURI(uri: part.uri) {
                let model = SFAPI.JSONtoModel(json: jsonPart)
                related.append(RelatedEntry(component: part.component, card: model))
            }
        }
    }
}
