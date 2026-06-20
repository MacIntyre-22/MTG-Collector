//
//  SymbolCache.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Renders Scryfall SVG card symbols ({W}, {T}, {2/U}, etc.) to UIImage using a single shared
//      WKWebView. Requests are queued serially: the SVG text is downloaded via URLSession (backed
//      by URLCache), embedded in a minimal HTML page at native colours, and the snapshot is stored
//      in NSCache *and written to disk as a PNG*. The disk copy is the key win — rendering a pip
//      through the WKWebView costs ~100 ms and a card view has many, so without persistence every
//      launch re-rendered them all and the first card/stat screen lagged badly. Now a symbol is
//      rendered once ever; later launches read the PNG straight off disk. `warmCommon()` pre-renders
//      the everyday mana pips during the launch gate so the first screen is instant.
//  External Types:
//      SymbolStore
//

// MARK: Imports

import WebKit
import UIKit

// MARK: Cache

@MainActor
final class SymbolCache: NSObject, WKNavigationDelegate {

    static let shared = SymbolCache()

    // MARK: Private types

    private struct RenderJob {
        let symbol: String
        let uri: String
        let continuation: CheckedContinuation<UIImage?, Never>
    }

    // MARK: Private state

    private let memory = NSCache<NSString, UIImage>()
    private let webView: WKWebView
    private var queue: [RenderJob] = []
    private var active: RenderJob?

    /// Render at 40pt — callers scale down to their required display size.
    private static let renderSize: CGFloat = 40

    /// On-disk home for rendered pips, so they survive app quits (the whole point — no re-render
    /// storm on launch). Lives in Caches: the OS may evict under storage pressure, and a missing
    /// file just re-renders.
    private static let diskDir: URL = {
        let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("symbol-images", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }()

    /// The everyday pips worth pre-rendering at launch (WUBRG, colourless, tap, low generic costs).
    static let commonSymbols = ["{W}", "{U}", "{B}", "{R}", "{G}", "{C}", "{X}", "{T}", "{Q}", "{S}",
                                "{0}", "{1}", "{2}", "{3}", "{4}", "{5}", "{6}", "{7}"]

    /// Filesystem-safe, stable filename for a symbol ("{2/U}" → "_2_U_.png").
    private static func diskURL(for symbol: String) -> URL {
        let name = String(symbol.unicodeScalars.map { CharacterSet.alphanumerics.contains($0) ? Character($0) : "_" })
        return diskDir.appendingPathComponent(name + ".png")
    }

    // MARK: Init

    private override init() {
        memory.countLimit = 200

        let size = CGSize(width: SymbolCache.renderSize, height: SymbolCache.renderSize)
        let config = WKWebViewConfiguration()
        config.suppressesIncrementalRendering = true
        webView = WKWebView(frame: CGRect(origin: .zero, size: size), configuration: config)
        super.init()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
    }

    // MARK: Public API

    func image(for symbol: String) -> UIImage? {
        memory.object(forKey: symbol as NSString)
    }

    func load(symbol: String, uri: String) async -> UIImage? {
        if let cached = image(for: symbol) { return cached }          // memory
        if let disk = await diskImage(for: symbol) {                  // disk (survives launches)
            memory.setObject(disk, forKey: symbol as NSString)
            return disk
        }
        return await withCheckedContinuation { cont in               // render once, then persist
            let job = RenderJob(symbol: symbol, uri: uri, continuation: cont)
            if active == nil { process(job) } else { queue.append(job) }
        }
    }

    /// Pre-render the everyday pips so the first card/stat screen draws instantly. Cheap after the
    /// first ever launch (each is a disk read). Safe to call at launch — runs through the same queue.
    func warmCommon() async {
        for symbol in Self.commonSymbols where image(for: symbol) == nil {
            guard let uri = SymbolStore.uri(for: symbol) else { continue }
            _ = await load(symbol: symbol, uri: uri)
        }
    }

    /// Read a previously rendered PNG off the main thread. Nil if never rendered or evicted.
    private func diskImage(for symbol: String) async -> UIImage? {
        let url = Self.diskURL(for: symbol)
        return await Task.detached(priority: .userInitiated) {
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data)
        }.value
    }

    // MARK: Private rendering

    private func process(_ job: RenderJob) {
        active = job
        Task.detached(priority: .userInitiated) {
            guard let url = URL(string: job.uri),
                  let (data, _) = try? await URLSession.shared.data(from: url),
                  let svg = String(data: data, encoding: .utf8) else {
                await MainActor.run { self.finish(image: nil) }
                return
            }
            await MainActor.run { self.renderHTML(svg) }
        }
    }

    private func renderHTML(_ svg: String) {
        let s = Int(Self.renderSize)
        // Render at natural SVG colours — mana pips have their own colour scheme.
        let html = """
        <!DOCTYPE html><html>
        <head><meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
        <style>
        *{margin:0;padding:0;box-sizing:border-box}
        html,body{width:\(s)px;height:\(s)px;background:transparent;overflow:hidden;
                  display:flex;align-items:center;justify-content:center}
        svg{width:\(s)px;height:\(s)px}
        </style></head>
        <body>\(svg)</body></html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

    private func finish(image: UIImage?) {
        if let image, let symbol = active?.symbol {
            memory.setObject(image, forKey: symbol as NSString)
            // Persist so this pip never has to be re-rendered on a future launch.
            if let png = image.pngData() {
                let url = Self.diskURL(for: symbol)
                Task.detached(priority: .utility) { try? png.write(to: url, options: .atomic) }
            }
        }
        active?.continuation.resume(returning: image)
        active = nil
        if let next = queue.first {
            queue.removeFirst()
            process(next)
        }
    }

    // MARK: WKNavigationDelegate

    nonisolated func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(80))
            let config = WKSnapshotConfiguration()
            config.rect = CGRect(origin: .zero, size: CGSize(width: Self.renderSize, height: Self.renderSize))
            config.afterScreenUpdates = true
            let image = try? await webView.takeSnapshot(configuration: config)
            self.finish(image: image)
        }
    }

    nonisolated func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Task { @MainActor in self.finish(image: nil) }
    }

    nonisolated func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Task { @MainActor in self.finish(image: nil) }
    }
}

// MARK: UIImage scale helper

extension UIImage {
    /// Returns a copy resized to `pointSize × pointSize` at the main screen's scale, with optional
    /// transparent margins baked onto the left/right. The margin is the cleanest way to give an
    /// inline `Text(Image(...))` symbol breathing room from adjacent words — a Text-level space would
    /// fight word wrapping, whereas this travels with the glyph itself.
    func scaledToPoint(_ pointSize: CGFloat, horizontalPadding: CGFloat = 0) -> UIImage {
        let canvas = CGSize(width: pointSize + horizontalPadding * 2, height: pointSize)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: canvas, format: format).image { _ in
            draw(in: CGRect(x: horizontalPadding, y: 0, width: pointSize, height: pointSize))
        }
    }
}
