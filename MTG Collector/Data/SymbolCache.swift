//
//  SymbolCache.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Renders Scryfall SVG card symbols ({W}, {T}, {2/U}, etc.) to UIImage using a single shared
//      WKWebView. Requests are queued serially: the SVG text is downloaded via URLSession (backed
//      by URLCache), embedded in a minimal HTML page at native colours, and the snapshot is stored
//      in NSCache. Callers scale the result down to their required point size.
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
        if let cached = image(for: symbol) { return cached }
        return await withCheckedContinuation { cont in
            let job = RenderJob(symbol: symbol, uri: uri, continuation: cont)
            if active == nil { process(job) } else { queue.append(job) }
        }
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
    /// Returns a copy resized to `pointSize × pointSize` points at the main screen's scale.
    func scaledToPoint(_ pointSize: CGFloat) -> UIImage {
        let size = CGSize(width: pointSize, height: pointSize)
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
