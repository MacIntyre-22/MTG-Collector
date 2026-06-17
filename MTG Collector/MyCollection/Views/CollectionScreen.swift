//
//  CollectionScreen.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Shared scaffolding for the Binder and Deck screens (which are near-identical now that
//      both inherit from Collection). Provides a full-bleed blurred cover-art background, a
//      scrolling HeaderWidget, and a slot for the caller's content (a binder's card grid or a
//      deck's boards). Type-specific toolbars, sheets and card cells stay in the calling view.
//  External Types:
//      HeaderWidget
//

// MARK: Imports

import SwiftUI
import UIKit

// MARK: Background

/// Full-bleed, blurred cover image used behind a collection screen — the same treatment as the
/// full-screen card view. A translucent system-background scrim keeps foreground content legible.
struct CollectionBackground: View {

    let image: UIImage

    var body: some View {
        GeometryReader { geo in
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .blur(radius: 35, opaque: true)
                .overlay(Color(.systemBackground).opacity(0.55))
        }
        .ignoresSafeArea()
    }
}

// MARK: Screen

struct CollectionScreen<Content: View>: View {

    // MARK: Stored Properties

    let coverImage: UIImage
    /// Whether the collection has a real cover image (vs the generic fallback icon).
    var hasCover: Bool = true
    let showCover: Bool
    let name: String
    let stats: CollectionStats?
    let count: Int
    @ViewBuilder var content: () -> Content

    // MARK: View

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HeaderWidget(
                    showCover: showCover,
                    coverImage: coverImage,
                    name: name,
                    stats: stats,
                    count: count
                )
                content()
            }
        }
        // With a cover: blurred art background + clearer glass on the cards so it reads through.
        // Without one: the plain system background + solid glass tiles, like the flat screens.
        .environment(\.cardGlass, hasCover ? .translucent : .solid)
        .background {
            if hasCover {
                CollectionBackground(image: coverImage)
            } else {
                Color(.systemBackground)
            }
        }
    }
}
