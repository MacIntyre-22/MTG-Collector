//
//  CardInfoView.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//      Displays all the info for a card model. A large card image sits at the top over a blurred
//      full-art background. Double-faced cards can be flipped — the image, name, background and
//      info section all update live to the current face.
//  External Types:
//      Card, CardFace, ImageURIs, InfoDisplayWidget, SetIconWidget, InfoLegalWidget, InfoRelatedWidget, InfoPriceWidget, ExternalResourcesWidget, InfoOtherWidget, CardImageView, CollectionControlWidget
//

// MARK: Imports

import SwiftUI
import SwiftData

// MARK: Types

struct CardInfoView: View {

    // MARK: Stored Properties

    var card: Card

    // MARK: State Properties

    @Environment(\.modelContext) var modelContext
    /// Whether a double-faced card is currently showing its back face.
    @State private var isFlipped: Bool = false
    /// Vertical scroll offset, used to shrink the card as the user scrolls down.
    @State private var scrollY: CGFloat = 0

    // MARK: Derived

    /// Faces that actually carry their own artwork (transform / modal DFCs). Split, adventure and
    /// flip layouts list faces but share one image, so we only treat genuinely two-sided cards as
    /// flippable.
    private var imageFaces: [CardFace] {
        guard card.cardFaces.count > 1 else { return [] }
        let withArt = card.cardFaces.filter { !bestURL($0.imageURIs).isEmpty }
        return withArt.count > 1 ? card.cardFaces : []
    }

    private var flippable: Bool { !imageFaces.isEmpty }

    /// The face currently in view, if this is a flippable card.
    private var currentFace: CardFace? {
        guard flippable else { return nil }
        return isFlipped ? imageFaces.last : imageFaces.first
    }

    private var currentName: String { currentFace?.name ?? card.name }
    private var currentImageURIs: ImageURIs { currentFace?.imageURIs ?? card.imageURIs }

    /// Card shrinks from full size to 82% over the first 250pt of downward scroll, and grows
    /// back as the user returns to the top.
    private var cardScale: CGFloat {
        let t = min(max(scrollY, 0), 250) / 250
        return 1 - 0.18 * t
    }

    // MARK: View

    var body: some View {
        NavigationStack {
            ZStack {

                /// Blurred full-art background of the current face. Sized from the screen so it fills
                /// and clips to the bounds (incl. safe area) without inflating the layout.
                GeometryReader { geo in
                    AsyncImage(url: URL(string: bestURL(currentImageURIs))) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                                .blur(radius: 35, opaque: true)
                                // Adaptive scrim (same as binder/deck screens) so default text
                                // colour reads in both light and dark mode.
                                .overlay(Color(.systemBackground).opacity(0.55))
                        } else {
                            Color(.systemBackground)
                        }
                    }
                    .id(isFlipped)
                    .transition(.opacity)
                }
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {

                        cardImage
                            .scaleEffect(cardScale, anchor: .top)
                            .padding(.top, 8)

                        /// Details — info for the current face (or the whole card when single-faced).
                        section("Details") {
                            VStack(alignment: .leading) {
                                if let face = currentFace {
                                    InfoDisplayWidget(
                                        name: face.name,
                                        manaCost: face.manaCost,
                                        cmc: face.cmc,
                                        typeLine: face.typeLine,
                                        colorIdentity: card.colorIdentity,
                                        power: face.power,
                                        toughness: face.toughness,
                                        loyalty: face.loyalty,
                                        defense: face.defense,
                                        keywords: face.keywords,
                                        producedMana: face.producedMana,
                                        oracleText: face.oracleText,
                                        flavorText: face.flavorText
                                    )
                                } else {
                                    InfoDisplayWidget(
                                        manaCost: card.manaCost,
                                        cmc: card.cmc,
                                        typeLine: card.typeLine,
                                        colorIdentity: card.colorIdentity,
                                        power: card.power,
                                        toughness: card.toughness,
                                        loyalty: card.loyalty,
                                        defense: card.defense,
                                        keywords: card.keywords,
                                        producedMana: card.producedMana,
                                        oracleText: card.oracleText,
                                        flavorText: card.flavorText
                                    )
                                }

                                SetIconWidget(set: card.set, rarity: card.rarity, maxWidth: 50)
                            }
                            .padding(15)
                            .cornerRadius(9)
                            .widgetStyle()
                        }

                        /// Legalities info here
                        section("Legalities") {
                            InfoLegalWidget(legalities: card.legalities)
                        }

                        /// related card items
                        if !card.allParts.isEmpty {
                            section("Related Cards") {
                                InfoRelatedWidget(cardParts: card.allParts)
                            }
                        }

                        /// pricing info
                        if !(card.prices.usd.isEmpty && card.prices.usdFoil.isEmpty && card.prices.usdEtched.isEmpty) {
                            section("Prices") {
                                InfoPriceWidget(prices: card.prices)
                            }
                        }

                        /// External links (Scryfall, EDHREC, Gatherer, vendors)
                        section("Resources") {
                            ExternalResourcesWidget(context: .card(card))
                        }

                        /// Additional info here
                        section("More Info") {
                            InfoOtherWidget(
                                releasedAt: card.releasedAt,
                                finishes: card.finishes,
                                set: card.set,
                                setName: card.setName,
                                artist: card.artist,
                                collectorNumber: card.collectorNumber,
                                edhrecRank: card.edhrecRank,
                                reserved: card.reserved
                            )
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .environment(\.widgetGlass, .translucent)
                .onScrollGeometryChange(for: CGFloat.self) { geo in
                    geo.contentOffset.y + geo.contentInsets.top
                } action: { _, newValue in
                    scrollY = newValue
                }
            }
            .navigationTitle(currentName)
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Add", systemImage: "plus") {
                        CollectionControllWidget(card: card)
                    }
                }
            })
        }
    }

    // MARK: Subviews

    /// Large card image at the top, with the same 3D flip control used in the card grid.
    private var cardImage: some View {
        ZStack {
            if flippable, let front = imageFaces.first, let back = imageFaces.last {
                CardImageView(maxWidth: 320, name: front.name, imageURIs: front.imageURIs)
                    .opacity(isFlipped ? 0 : 1)
                    .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

                CardImageView(maxWidth: 320, name: back.name, imageURIs: back.imageURIs)
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation(.easeInOut(duration: 0.6)) { isFlipped.toggle() }
                        } label: {
                            Image(systemName: "arrow.left.arrow.right.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .shadow(radius: 7)
                        }
                    }
                    Spacer()
                }
                .padding(.top, 14)
                .padding(.trailing, 18)
            } else {
                CardImageView(maxWidth: 320, name: card.name, imageURIs: card.imageURIs)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    /// A titled section: a leading header above its content.
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title3.weight(.semibold))
                .padding(.horizontal, 4)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Helpers

    /// Best available image URL for a face, mirroring CardImageView's preference order.
    private func bestURL(_ uris: ImageURIs) -> String {
        if !uris.png.isEmpty { return uris.png }
        if !uris.large.isEmpty { return uris.large }
        if !uris.normal.isEmpty { return uris.normal }
        if !uris.small.isEmpty { return uris.small }
        return ""
    }
}
