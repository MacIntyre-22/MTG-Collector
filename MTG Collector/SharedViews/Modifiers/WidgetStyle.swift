//
//  WidgetStyle.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Shared ViewModifier for widget cards. Applies Liquid Glass (iOS 26) so widgets read
//      well in both light and dark mode with no manual background/shadow/border styling.
//      The app floor is iOS 26, so .glassEffect() is applied unconditionally (no fallback).

// MARK: Imports

import SwiftUI

// MARK: Types

private struct WidgetStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: Extension

extension View {
    func widgetStyle() -> some View {
        modifier(WidgetStyle())
    }
}
