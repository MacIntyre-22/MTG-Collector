//
//  ExternalResourcesWidget.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Reusable section that lists external links for a given context (card / commander /
//      deck / binder). Each row opens in the in-app WebSheet. Renders nothing when no
//      resources are available, so callers can drop it in unconditionally.
//  External Types:
//      ExternalResourcesManager, ExternalResourcesContext, ExternalResource, WebSheet

// MARK: Imports

import SwiftUI

// MARK: Types

struct ExternalResourcesWidget: View {

    // MARK: Stored Properties

    var context: ExternalResourcesContext
    var title: String = "Resources"

    // MARK: State Properties

    @State private var webURL: URL?

    private var resources: [ExternalResource] {
        ExternalResourcesManager.resources(for: context)
    }

    // MARK: View

    var body: some View {
        if !resources.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.title3)
                    .bold()

                ForEach(resources) { resource in
                    Button {
                        webURL = resource.url
                    } label: {
                        HStack {
                            Image(systemName: resource.iconSystemName)
                                .frame(width: 26)
                                .foregroundColor(.accentColor)
                            Text(resource.title)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    if resource.id != resources.last?.id {
                        Divider()
                    }
                }
            }
            .padding(15)
            .frame(maxWidth: 600)
            .widgetStyle()
            .sheet(item: $webURL) { url in
                WebSheet(url: url)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// MARK: - URL Identifiable

/// Lets `.sheet(item:)` present a WebSheet directly from a URL.
extension URL: Identifiable {
    public var id: String { absoluteString }
}
