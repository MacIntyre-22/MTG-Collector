//
//  WebSheet.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-02.
//

import SwiftUI
import WebKit

struct WebSheet: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

