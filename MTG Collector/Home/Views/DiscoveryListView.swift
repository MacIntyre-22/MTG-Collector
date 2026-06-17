//
//  DiscoveryListView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Loads and shows the cards for a themed quick-link query in a grid. Pushed from the Home feed
//      (inside its NavigationStack), so it doesn't wrap its own.
//  External Types:
//      CardJSON, SFAPI, SearchCardView
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct DiscoveryListView: View {

    // MARK: Stored Properties

    var title: String
    var systemImage: String
    var query: String
    let columns = [GridItem(.adaptive(minimum: 180, maximum: 180), spacing: 15)]

    // MARK: State Properties

    @State private var cards: [CardJSON] = []
    @State private var loading = true

    // MARK: View

    var body: some View {
        ScrollView {
            if loading {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
            } else if cards.isEmpty {
                ContentUnavailableView("Nothing found", systemImage: systemImage)
                    .padding(.top, 40)
            } else {
                LazyVGrid(columns: columns) {
                    ForEach(cards) { card in
                        SearchCardView(card: SFAPI.JSONtoModel(json: card))
                    }
                }
                .padding(.horizontal, 10)
            }
        }
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.large)
        .task {
            cards = await SFAPI.fetchCardQuery(query: query)
            loading = false
        }
    }
}
