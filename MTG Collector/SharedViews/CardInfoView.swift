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
    @Environment(\.appCurrency) private var currency
    /// Whether a double-faced card is currently showing its back face.
    @State private var isFlipped: Bool = false
    /// Vertical scroll offset, used to shrink the card as the user scrolls down.
    @State private var scrollY: CGFloat = 0
    /// Card rulings, fetched once from `rulings_uri` when the sheet opens.
    @State private var rulings: [Ruling] = []

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

    /// Related parts worth showing: drop the card itself (tokens list themselves in `all_parts`).
    private var relatedParts: [RelatedCardObject] {
        card.allParts.filter { $0.id != card.id && !$0.id.isEmpty }
    }

    /// Generic tokens (Food, Treasure, Clue…) list *every* card that makes them — dozens to hundreds
    /// — which is noise and slow to load. Only show Related Cards for a sensible handful.
    private var showsRelated: Bool { (1...15).contains(relatedParts.count) }

    /// Notable card traits (Alchemy, Reserved List, card type…) shown as tappable pills in Details.
    private var cardTraits: [InfoDetail] { CardTraits.traits(for: card) }

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
                                    // Flippable DFC — details for the face currently in view.
                                    faceDetails(face, traits: cardTraits)
                                } else if card.cardFaces.count > 1 {
                                    // Single-image multi-face (split / aftermath / adventure / flip):
                                    // no face to flip to, so stack each half's details with a divider.
                                    // Card-level trait pills show once, above the first face only.
                                    ForEach(Array(card.cardFaces.enumerated()), id: \.offset) { index, face in
                                        if index > 0 {
                                            Divider().padding(.vertical, 8)
                                        }
                                        faceDetails(face, traits: index == 0 ? cardTraits : [])
                                    }
                                } else {
                                    // Truly single-faced — name lives in the nav title.
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
                                        flavorText: card.flavorText,
                                        traits: cardTraits
                                    )
                                }

                                SetIconWidget(set: card.set, rarity: card.rarity, maxWidth: 50)
                            }
                            .padding(15)
                            .cornerRadius(9)
                            .widgetStyle()
                            // Flip control lives here for two-faced cards, aligned with the name.
                            .overlay(alignment: .topTrailing) {
                                if flippable {
                                    flipButton.padding(15)
                                }
                            }
                        }

                        /// Card rulings — each ruling its own collapsible row; only shown when present
                        if !rulings.isEmpty {
                            section("Rulings") {
                                InfoRulingsWidget(rulings: rulings)
                            }
                        }

                        /// Legalities info here
                        section("Legalities") {
                            InfoLegalWidget(legalities: card.legalities)
                        }

                        /// related card items (hidden for generic-token dumps — see `showsRelated`)
                        if showsRelated {
                            section("Related Cards") {
                                InfoRelatedWidget(cardParts: relatedParts)
                            }
                        }

                        /// pricing info — only when the selected currency has any price for this card
                        if !currency.cardPrices(card.prices).isEmpty {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    // Name with inline icons (Alchemy "A-" → flask, "//" → a layout-based glyph).
                    CardNameView(name: currentName, layout: card.layout)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Add", systemImage: "plus") {
                        CollectionControllWidget(card: card)
                    }
                }
            })
            .task {
                guard rulings.isEmpty, !card.rulingsURI.isEmpty else { return }
                rulings = await SFAPI.fetchRulings(uri: card.rulingsURI)
            }
        }
    }

    // MARK: Subviews

    /// One face's details, headed by its own name. Used both for the current face of a flippable
    /// DFC and for each half of a single-image multi-face card (split / adventure / aftermath / flip).
    private func faceDetails(_ face: CardFace, traits: [InfoDetail] = []) -> some View {
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
            flavorText: face.flavorText,
            traits: traits
        )
    }

    /// Flip control for two-faced cards, styled as a chip to match the detail panel's keyword pills.
    private var flipButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.6)) { isFlipped.toggle() }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "arrow.left.arrow.right")
                Text("Flip")
            }
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.primary.opacity(0.08)))
        }
        .buttonStyle(.plain)
    }

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
