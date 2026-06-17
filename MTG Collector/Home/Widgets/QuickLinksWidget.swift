//
//  QuickLinksWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      A Home feed row of glass-capsule quick links — each opens a themed card discovery
//      (DiscoveryListView). The set of links is chosen daily by HomeFeed.
//  External Types:
//      QuickLink, DiscoveryListView
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct QuickLinksWidget: View {

    // MARK: Stored Properties

    let links: [QuickLink]

    // MARK: View

    var body: some View {
        VStack(alignment: .leading) {
            Label("Quick Links", systemImage: "bolt.fill")
                .font(.title2)
                .bold()
                .padding(.horizontal, 15)
                .padding(.top, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(links) { link in
                        NavigationLink {
                            DiscoveryListView(title: link.title, systemImage: link.systemImage, query: link.query)
                        } label: {
                            Label(link.title, systemImage: link.systemImage)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .pillStyle()
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 20)
        }
        .widgetStyle()
    }
}
