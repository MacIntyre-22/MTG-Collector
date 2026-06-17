//
//  SetIconCache.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Renders Scryfall SVG set icons to UIImage using a single shared WKWebView. Requests are
//      queued and processed serially: the SVG text is downloaded via URLSession (backed by
//      URLCache), embedded in a styled HTML page that forces white fill, and the snapshot is stored
//      in an NSCache for instant re-use.
//  External Types:
//      (WebKit, UIKit)
//

// MARK: Imports

import WebKit
import UIKit

// MARK: Cache

@MainActor
final class SetIconCache: NSObject, WKNavigationDelegate {

    static let shared = SetIconCache()

    // MARK: Private types

    private struct RenderJob {
        let code: String
        let uri: String
        let continuation: CheckedContinuation<UIImage?, Never>
    }

    // MARK: Private state

    private let memory = NSCache<NSString, UIImage>()
    private let webView: WKWebView
    private var queue: [RenderJob] = []
    private var active: RenderJob?

    private static let size = CGSize(width: 80, height: 80)

    // MARK: Init

    private override init() {
        memory.countLimit = 600

        let config = WKWebViewConfiguration()
        config.suppressesIncrementalRendering = true
        webView = WKWebView(frame: CGRect(origin: .zero, size: SetIconCache.size), configuration: config)
        super.init()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
    }

    // MARK: Public API

    func image(for code: String) -> UIImage? {
        memory.object(forKey: code as NSString)
    }

    func load(code: String, uri: String) async -> UIImage? {
        if let cached = image(for: code) { return cached }
        return await withCheckedContinuation { cont in
            let job = RenderJob(code: code, uri: uri, continuation: cont)
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
        // Embed the raw SVG so CSS can reach its elements directly.
        // Force all path fills to white so the icon reads on any coloured background.
        let s = Int(Self.size.width)
        let html = """
        <!DOCTYPE html><html>
        <head><meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no">
        <style>
        *{margin:0;padding:0;box-sizing:border-box}
        html,body{width:\(s)px;height:\(s)px;background:transparent;overflow:hidden;
                  display:flex;align-items:center;justify-content:center}
        svg{width:\(s - 10)px;height:\(s - 10)px;fill:white}
        svg *{fill:white!important;stroke:none!important}
        </style></head>
        <body>\(svg)</body></html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }

    private func finish(image: UIImage?) {
        if let image, let code = active?.code {
            memory.setObject(image, forKey: code as NSString)
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
            // Brief settle so WebKit finishes painting before we snapshot.
            try? await Task.sleep(for: .milliseconds(80))
            let config = WKSnapshotConfiguration()
            config.rect = CGRect(origin: .zero, size: Self.size)
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
