//
//  WidgetStyle.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Shared ViewModifier for widget cards — consistent background, corner radius, and shadow.

// MARK: Imports

import SwiftUI

// MARK: Types

private struct WidgetStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .gray.opacity(0.25), radius: 6, x: 0, y: 0)
            )
    }
}

// MARK: Extension

extension View {
    func widgetStyle() -> some View {
        modifier(WidgetStyle())
    }
}
