//
//  WebSheet.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-10-02.
//  Purpose:
//      The in-app browser sheet used everywhere external links open (resources, news, about). A thin
//      SwiftUI wrapper around a WKWebView that adds a little space at the top and a drag grabber, so
//      the sheet reads clearly and can be pulled down to dismiss without fighting the web content.
//      One definition, so every `WebSheet(url:)` call gets the same treatment.
//

// MARK: Imports

import SwiftUI
import WebKit

// MARK: Sheet

struct WebSheet: View {

    let url: URL

    var body: some View {
        VStack(spacing: 0) {
            // A generous pull-down strip above the web content: clears the sheet's rounded top
            // corners (so the page edge reads flush) and gives an easy grab area to dismiss.
            Color.clear.frame(height: 44)

            WebView(url: url)
                .ignoresSafeArea(edges: .bottom)
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: Web view

/// The raw WKWebView. Kept private to the wrapper above so callers always get the sheet chrome.
private struct WebView: UIViewRepresentable {

    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.load(URLRequest(url: url))
    }
}
