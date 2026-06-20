//
//  BrandLogo.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Loads official site logos for outbound links and news sources. Tries Clearbit's logo API
//      first (true brand mark, full colour), falling back to DuckDuckGo's favicon service when a
//      domain has no Clearbit logo. Results are cached on disk via ImageCache, so each logo is
//      fetched once and reused everywhere (links list + news widget) and across launches. Logos
//      are always drawn in their own colours — never recoloured.
//  External Types:
//      ImageCache
//

// MARK: Imports

import SwiftUI
import UIKit

// MARK: Loader

enum BrandLogo {

    /// Logo sources in priority order: Clearbit's brand logo, then DuckDuckGo's favicon.
    private static func candidateURLs(for domain: String) -> [URL] {
        [
            "https://logo.clearbit.com/\(domain)",
            "https://icons.duckduckgo.com/ip3/\(domain).ico"
        ].compactMap { URL(string: $0) }
    }

    /// The registrable host for a URL (drops a leading "www."), used as the logo lookup key.
    static func domain(from url: URL) -> String? {
        guard let host = url.host() else { return nil }
        return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
    }

    /// A synchronously available logo if one of the sources is already cached.
    static func cached(domain: String) -> UIImage? {
        for url in candidateURLs(for: domain) {
            if let hit = ImageCache.shared.image(for: url) { return hit }
        }
        return nil
    }

    /// Resolve a logo, trying each source in turn. A source that 404s decodes to nil, so we fall
    /// through to the next. Returns nil only when no source has a usable image.
    static func load(domain: String) async -> UIImage? {
        for url in candidateURLs(for: domain) {
            if let image = await ImageCache.shared.load(url) { return image }
        }
        return nil
    }
}

// MARK: View

/// Draws a site's official logo for `domain`, showing `fallback` while it loads or if no source
/// has one. The logo keeps its own colours (no template tint).
struct BrandLogoView<Fallback: View>: View {

    let domain: String?
    @ViewBuilder let fallback: () -> Fallback

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                fallback()
            }
        }
        .task(id: domain) {
            guard let domain else { return }
            if let hit = BrandLogo.cached(domain: domain) {
                image = hit
                return
            }
            image = await BrandLogo.load(domain: domain)
        }
    }
}
