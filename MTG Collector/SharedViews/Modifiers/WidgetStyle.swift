//
//  WidgetStyle.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-15.
//  Purpose:
//      Central Liquid Glass palette + modifiers. Define each glass treatment once in `AppGlass`
//      and apply it by name, so changing how a treatment looks is a one-line change here rather
//      than across every call site.
//        • widgetStyle(_:) — rounded-rectangle container (widgets, card tiles)
//        • pillStyle(_:)    — capsule (small chips)
//      The app floor is iOS 26, so glass is applied unconditionally (no fallback).

// MARK: Imports

import SwiftUI

// MARK: Glass Palette

/// The named glass treatments used across the app. Add a case to introduce a new look.
enum AppGlass {
    /// Frosted, for page widgets over solid backgrounds.
    case solid
    /// Clearer/translucent, for card tiles that sit over imagery (e.g. a blurred cover).
    case translucent
    /// Coloured glass for semantic chips (rarity, price finish, …).
    case tinted(Color)

    var glass: Glass {
        switch self {
        case .solid: return .regular
        case .translucent: return .clear
        case .tinted(let color): return .regular.tint(color)
        }
    }
}

// MARK: Modifiers

extension View {

    /// Rounded-rectangle glass container — widgets and card tiles.
    func widgetStyle(_ style: AppGlass = .solid, cornerRadius: CGFloat = 10) -> some View {
        glassEffect(style.glass, in: RoundedRectangle(cornerRadius: cornerRadius))
    }

    /// Capsule glass — small chips/pills.
    func pillStyle(_ style: AppGlass = .solid) -> some View {
        glassEffect(style.glass, in: Capsule())
    }
}

// MARK: Card Tile Glass (environment)

private struct CardGlassKey: EnvironmentKey {
    static let defaultValue: AppGlass = .solid
}

extension EnvironmentValues {
    /// Glass treatment for card tiles. Defaults to `.solid` (flat backgrounds: search, Home,
    /// General collection); screens over cover imagery (binder/deck) set `.translucent`.
    var cardGlass: AppGlass {
        get { self[CardGlassKey.self] }
        set { self[CardGlassKey.self] = newValue }
    }
}
