//
//  NewsFeedWidget.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Displays the latest MTG news from MTGGoldfish, Wizards, and r/magicTCG.
//      Each row shows a thumbnail (or source icon), headline, source badge, and relative date.
//      Tapping a row opens the article in an in-app WebSheet.
//  External Types:
//      NewsItem, NewsSource, CachedAsyncImage, WebSheet
//

// MARK: Imports

import SwiftUI

// MARK: Types

struct NewsFeedWidget: View {

    // MARK: Stored Properties

    var items: [NewsItem]
    var isLoading: Bool

    // MARK: State Properties

    @State private var openItem: NewsItem?

    // MARK: View

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            if isLoading && items.isEmpty {
                skeletonRows
            } else {
                ForEach(items.prefix(5)) { item in
                    Button { openItem = item } label: { row(item) }
                    .buttonStyle(.plain)

                    if item.id != items.prefix(5).last?.id {
                        Divider().padding(.horizontal, 15)
                    }
                }
            }
        }
        .cornerRadius(9)
        .widgetStyle()
        .sheet(item: $openItem) { item in
            if let url = URL(string: item.link) {
                WebSheet(url: url)
                    .ignoresSafeArea()
            }
        }
    }

    // MARK: Subviews

    private var header: some View {
        HStack {
            Label("MTG News", systemImage: "newspaper.fill")
                .font(.title2.bold())
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    private func row(_ item: NewsItem) -> some View {
        HStack(spacing: 12) {
            thumbnail(item)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    BrandLogoView(domain: item.source.domain) {
                        Image(systemName: item.source.systemImage)
                            .foregroundColor(item.source.color)
                    }
                    .frame(width: 14, height: 14)
                    .clipShape(RoundedRectangle(cornerRadius: 3))

                    Text(item.source.rawValue)
                        .foregroundColor(item.source.color)
                }
                .font(.caption2.bold())

                Text(item.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Text(item.pubDate, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private func thumbnail(_ item: NewsItem) -> some View {
        let size: CGFloat = 72
        let radius: CGFloat = 8

        if let urlString = item.thumbnailURL, let url = URL(string: urlString) {
            CachedAsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                sourceIcon(item.source, size: size)
            }
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        } else {
            sourceIcon(item.source, size: size)
                .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
        }
    }

    private func sourceIcon(_ source: NewsSource, size: CGFloat) -> some View {
        source.color.opacity(0.15)
            .frame(width: size, height: size)
            .overlay(
                BrandLogoView(domain: source.domain) {
                    Image(systemName: source.systemImage)
                        .font(.title2)
                        .foregroundColor(source.color)
                }
                .frame(width: size * 0.5, height: size * 0.5)
            )
    }

    private var skeletonRows: some View {
        VStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { i in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 72, height: 72)

                    VStack(alignment: .leading, spacing: 6) {
                        Capsule().fill(Color.gray.opacity(0.2)).frame(width: 80, height: 10)
                        Capsule().fill(Color.gray.opacity(0.2)).frame(height: 12)
                        Capsule().fill(Color.gray.opacity(0.2)).frame(width: 100, height: 10)
                    }
                    Spacer()
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)

                if i < 4 { Divider().padding(.horizontal, 15) }
            }
        }
        .redacted(reason: .placeholder)
        .shimmering()
        .padding(.bottom, 4)
    }
}
