//
//  ExternalResourcesWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Reusable section that lists the outbound links for a given context (card / commander /
//      deck / binder). Each row opens in the in-app WebSheet. Only renders rows whose URL exists,
//      and for a deck it additionally resolves the commander to surface its EDHREC page.
//  External Types:
//      ExternalResourcesManager, ExternalResourcesContext, ExternalResource, ResourceIcon, CardStore, WebSheet
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct ExternalResourcesWidget: View {

    // MARK: Stored Properties

    let context: ExternalResourcesContext

    // MARK: State Properties

    @Environment(\.modelContext) private var modelContext
    @State private var webURI = URL(string: "about:blank")!
    @State private var showSheet = false
    /// Links resolved asynchronously (e.g. a deck's commander EDHREC page).
    @State private var extraResources: [ExternalResource] = []

    // MARK: Computed

    private var resources: [ExternalResource] {
        ExternalResourcesManager.resources(for: context) + extraResources
    }

    // MARK: View

    var body: some View {
        Group {
            if resources.isEmpty {
                EmptyView()
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(resources.enumerated()), id: \.element.id) { index, resource in
                        Button {
                            webURI = resource.url
                            showSheet = true
                        } label: {
                            row(resource)
                        }
                        .buttonStyle(.plain)

                        if index < resources.count - 1 {
                            Divider().padding(.leading, 44)
                        }
                    }
                }
                .padding(15)
                .cornerRadius(9)
                .widgetStyle()
            }
        }
        .task { await loadExtras() }
        .sheet(isPresented: $showSheet) {
            WebSheet(url: webURI)
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: Subviews

    private func row(_ resource: ExternalResource) -> some View {
        HStack(spacing: 12) {
            icon(resource.icon)
                .frame(width: 26, height: 26)
            Text(resource.title)
            Spacer()
            Image(systemName: "arrow.up.right")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .contentShape(Rectangle())
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func icon(_ icon: ResourceIcon) -> some View {
        switch icon {
        case .asset(let name):
            Image(name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.tint)
        case .symbol(let name):
            Image(systemName: name)
                .font(.title3)
                .foregroundStyle(.tint)
        }
    }

    // MARK: Async resolution

    private func loadExtras() async {
        guard extraResources.isEmpty else { return }
        // A commander deck links out to its commander's EDHREC page — resolve the card to get it.
        if case .deck(let deck) = context, let commander = deck.commander {
            if let card = await CardStore.resolve(commander.scryfallCardID, context: modelContext) {
                extraResources = ExternalResourcesManager.resources(for: .commander(card))
            }
        }
    }
}
