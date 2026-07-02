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
import ImageIO

// MARK: Cache

final class ImageCache {

    static let shared = ImageCache()

    /// Decoded images kept in memory for instant redraws. URLCache (configured at app launch)
    /// backs this with on-disk persistence of the raw HTTP responses.
    private let memory = NSCache<NSURL, UIImage>()

    private init() {
        memory.countLimit = 200
        // Cap decoded-image memory. NSCache evicts by cost past this, so a long browsing session
        // can't pile up hundreds of MB of bitmaps and build the memory pressure that slowly heats
        // the device. Re-decoding an evicted image is cheap (downsampled ImageIO thumbnail).
        memory.totalCostLimit = 96 * 1024 * 1024   // ~96 MB
    }

    func image(for url: URL) -> UIImage? {
        memory.object(forKey: url as NSURL)
    }

    /// Approximate decoded byte size, used as the NSCache eviction cost.
    private static func cost(of image: UIImage) -> Int {
        guard let cg = image.cgImage else { return Int(image.size.width * image.size.height * 4) }
        return cg.bytesPerRow * cg.height
    }

    /// Returns a cached image immediately or downloads it, decoded down to `maxPixelSize` (longest
    /// edge, in pixels). Downloads hit URLCache first, so a previously fetched image loads from disk
    /// rather than the network. Downsampling keeps memory low and moves the decode off the draw path.
    func load(_ url: URL, maxPixelSize: CGFloat = 600) async -> UIImage? {
        if let hit = image(for: url) { return hit }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = Self.downsample(data, maxPixelSize: maxPixelSize) ?? UIImage(data: data) else { return nil }
            memory.setObject(image, forKey: url as NSURL, cost: Self.cost(of: image))
            return image
        } catch {
            return nil
        }
    }

    /// Warm the cache for images that are about to scroll into view, off the main path.
    func prefetch(_ urls: [URL], maxPixelSize: CGFloat = 600) {
        for url in urls where image(for: url) == nil {
            Task.detached(priority: .utility) { _ = await ImageCache.shared.load(url, maxPixelSize: maxPixelSize) }
        }
    }

    /// Decode `data` straight to a thumbnail at `maxPixelSize` via ImageIO — never materialises the
    /// full-resolution bitmap, so a 1 MB PNG doesn't cost megabytes of RAM to show in a small cell.
    private static func downsample(_ data: Data, maxPixelSize: CGFloat) -> UIImage? {
        let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let source = CGImageSourceCreateWithData(data as CFData, sourceOptions) else { return nil }
        let options = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: max(1, maxPixelSize)
        ] as CFDictionary
        guard let cg = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return nil }
        return UIImage(cgImage: cg)
    }
}

// MARK: CachedAsyncImage

/// Drop-in replacement for AsyncImage backed by ImageCache. Hands the loaded `Image` to `content`
/// so callers can style it (resize, corner radius, long-press, etc.) exactly as before.
struct CachedAsyncImage<Content: View, Placeholder: View>: View {

    let url: URL?
    /// Longest-edge cap (px) for the decoded image. Default suits grid cells; the full-screen
    /// viewer passes a larger value for a crisp zoom.
    var maxPixelSize: CGFloat = 600
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
            uiImage = await ImageCache.shared.load(url, maxPixelSize: maxPixelSize)
        }
    }
}
