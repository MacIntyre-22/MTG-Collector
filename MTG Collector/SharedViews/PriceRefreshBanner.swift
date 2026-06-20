//
//  PriceRefreshBanner.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      A small transient top banner shown on a collection screen when on-open price refresh updates
//      cards — so the user knows their totals just changed. Driven by a String? binding; auto-dismisses.
//

// MARK: Imports

import SwiftUI

// MARK: Banner

struct PriceRefreshBanner: View {
    let text: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text(text)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.primary.opacity(0.08)))
        .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
        .padding(.top, 10)
    }
}

// MARK: Presentation helper

extension View {
    /// Shows a transient top banner whenever `message` is set, then clears it after a moment.
    func priceRefreshBanner(_ message: Binding<String?>) -> some View {
        overlay(alignment: .top) {
            if let text = message.wrappedValue {
                PriceRefreshBanner(text: text)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .task {
                        try? await Task.sleep(for: .seconds(2.5))
                        withAnimation { message.wrappedValue = nil }
                    }
            }
        }
        .animation(.spring(duration: 0.4), value: message.wrappedValue)
    }
}
