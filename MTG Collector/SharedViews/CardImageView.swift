//
//  CardImageView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Displays a card's image and a long-press full-screen zoom. Grid/cell art loads the `normal`
//      size (downsampled for the cell) so scrolling stays cheap; the full-screen viewer loads the
//      crisp `png`/`large` only when opened, using the already-loaded cell image as a placeholder.
//  External Types:
//      ImageURIs

// MARK: Imports

import SwiftUI

// MARK: Types

struct CardImageView: View {

    // MARK: Stored Properties

    var maxWidth: Double
    var name: String
    var imageURIs: ImageURIs

    /// Cell/grid art. `normal` (~488×680) is ample for a tile and far cheaper than the ~1 MB png.
    private var displayURL: URL? {
        URL(string: firstNonEmpty(imageURIs.normal, imageURIs.small, imageURIs.large, imageURIs.png))
    }

    /// Full-screen zoom art — the crispest available.
    private var zoomURL: URL? {
        URL(string: firstNonEmpty(imageURIs.png, imageURIs.large, imageURIs.normal, imageURIs.small))
    }

    // MARK: State Properties

    @State private var showFullScreen: Bool = false

    // MARK: View

    var body: some View {
        ZStack {
            /// Fallback: card name on a gray background while (or if) the art doesn't load.
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .cornerRadius(8)

            Text(name)
                .bold()
                .padding(10)

            if let displayURL {
                CachedAsyncImage(url: displayURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .onLongPressGesture {
                            HapticManager.medium()
                            showFullScreen = true
                        }
                        .accessibilityLabel(name)
                        .accessibilityHint("Press and hold to view full screen")
                        .fullScreenCover(isPresented: $showFullScreen) {
                            // Load the crisp image for the zoom; show the cell image until it lands.
                            FullScreenCardView(zoomURL: zoomURL, lowRes: image) {
                                showFullScreen = false
                            }
                        }
                } placeholder: {
                    ProgressView()
                }
            }
        }
        /// Lock to the card aspect ratio and fill the available width.
        .aspectRatio(0.718, contentMode: .fit)
        .frame(maxWidth: maxWidth)
    }

    /// First non-empty string from the candidates (image URL preference order).
    private func firstNonEmpty(_ options: String...) -> String {
        options.first { !$0.isEmpty } ?? ""
    }
}

// MARK: Full screen

/// The long-press full-screen viewer. Loads `zoomURL` (png/large) for a crisp zoom while showing the
/// already-loaded cell image as a placeholder, so there's no flash. Tap anywhere to exit.
private struct FullScreenCardView: View {

    let zoomURL: URL?
    let lowRes: Image
    let onExit: () -> Void

    var body: some View {
        ZStack {
            card
            VStack {
                HStack {
                    Spacer()
                    Text("Tap to Exit")
                        .italic()
                        .bold()
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                }
                Spacer()
            }
            .padding(50)
        }
        .onTapGesture { onExit() }
    }

    @ViewBuilder private var card: some View {
        if let zoomURL {
            CachedAsyncImage(url: zoomURL, maxPixelSize: 1600) { hi in
                layout(hi)
            } placeholder: {
                layout(lowRes)
            }
        } else {
            layout(lowRes)
        }
    }

    /// Blurred art filling the background + the card itself centred on top.
    private func layout(_ image: Image) -> some View {
        ZStack {
            GeometryReader { geo in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .blur(radius: 35, opaque: true)
                    .overlay(Color.black.opacity(0.3))
            }
            .ignoresSafeArea()

            image
                .resizable()
                .scaledToFit()
                .cornerRadius(17)
                .padding()
                .frame(maxWidth: 600)
                .shadow(radius: 12)
        }
    }
}
