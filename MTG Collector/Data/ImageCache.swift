//
//  ImageCache.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Persistent image loading. SwiftUI's AsyncImage keeps no durable cache and silently drops
//      in-flight requests when a cell scrolls off or a tab switches — which is why card art would
//      sometimes never appear. ImageCache layers an in-memory NSCache over the on-disk URLCache so
//      a given image is downloaded once, survives scrolling/tab switches, and reappears instantly.
//      CachedAsyncImage is a near drop-in for AsyncImage built on top of it.
//  External Types:
//      (UIKit, SwiftUI)
//

// MARK: Imports

import SwiftUI
import UIKit

// MARK: Cache

final class ImageCache {

    static let shared = ImageCache()

    /// Decoded images kept in memory for instant redraws. URLCache (configured at app launch)
    /// backs this with on-disk persistence of the raw HTTP responses.
    private let memory = NSCache<NSURL, UIImage>()

    private init() {
        memory.countLimit = 400
    }

    func image(for url: URL) -> UIImage? {
        memory.object(forKey: url as NSURL)
    }

    /// Returns a cached image immediately or downloads it. Downloads hit URLCache first, so a
    /// previously fetched image loads from disk rather than the network.
    func load(_ url: URL) async -> UIImage? {
        if let hit = image(for: url) { return hit }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            memory.setObject(image, forKey: url as NSURL)
            return image
        } catch {
            return nil
        }
    }

    /// Warm the cache for images that are about to scroll into view, off the main path.
    func prefetch(_ urls: [URL]) {
        for url in urls where image(for: url) == nil {
            Task.detached(priority: .utility) { _ = await ImageCache.shared.load(url) }
        }
    }
}

// MARK: CachedAsyncImage

/// Drop-in replacement for AsyncImage backed by ImageCache. Hands the loaded `Image` to `content`
/// so callers can style it (resize, corner radius, long-press, etc.) exactly as before.
struct CachedAsyncImage<Content: View, Placeholder: View>: View {

    let url: URL?
    @ViewBuilder let content: (Image) -> Content
    @ViewBuilder let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        // Reloads when the URL changes (e.g. flipping a double-faced card). A memory hit resolves
        // synchronously on the next render, so there's no flash for already-loaded art.
        .task(id: url) {
            guard let url else { return }
            if let hit = ImageCache.shared.image(for: url) {
                uiImage = hit
                return
            }
            uiImage = await ImageCache.shared.load(url)
        }
    }
}
