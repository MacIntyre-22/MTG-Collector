//
//  Card.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-09-25.
//  Purpose:
//         Value-type model for a card, converted from CardJSON. Stored locally inside
//         CardCache (keyed by Scryfall ID). As a Codable struct it is cheap to pass
//         around views and never needs its own SwiftData identity.

// MARK: Imports

import Foundation

// MARK: Types

struct Card: Codable, Identifiable, Hashable {

    // MARK: Stored Properties

    var id: String
    var oracleID: String
    var name: String
    var releasedAt: String
    var imageStatus: String
    var imageURIs: ImageURIs

    /// mana
    var manaCost: String
    var cmc: Double
    var colors: [String]
    var colorIdentity: [String]
    var colorIndicator: [String]
    var producedMana: [String]

    /// text
    var typeLine: String
    var oracleText: String
    var keywords: [String]

    /// stats
    var toughness: String
    var power: String
    var loyalty: String
    var defense: String

    /// multi face cards
    var layout: String
    var cardFaces: [CardFace]

    /// other
    var rarity: String
    var flavorText: String
    var finishes: [String]
    var set: String
    var setName: String
    var artist: String
    var collectorNumber: String
    var edhrecRank: Int

    /// scryfall links
    var scryfallURI: String
    var rulingsURI: String
    var relatedURIs: RelatedURIs

    var prices: Prices
    var purchaseURIs: PurchaseURIs
    var allParts: [RelatedCardObject]
    var reserved: Bool
    var legalities: [String: String]

    init(
        id: String = "",
        oracleID: String = "",
        name: String = "",
        releasedAt: String = "",
        imageStatus: String = "",
        imageURIs: ImageURIs = ImageURIs(),
        manaCost: String = "",
        cmc: Double = 0.0,
        colors: [String] = [],
        colorIdentity: [String] = [],
        colorIndicator: [String] = [],
        producedMana: [String] = [],
        typeLine: String = "",
        oracleText: String = "",
        keywords: [String] = [],
        toughness: String = "",
        power: String = "",
        loyalty: String = "",
        defense: String = "",
        layout: String = "",
        cardFaces: [CardFace] = [],
        rarity: String = "",
        flavorText: String = "",
        finishes: [String] = [],
        set: String = "",
        setName: String = "",
        artist: String = "",
        collectorNumber: String = "",
        edhrecRank: Int = 0,
        scryfallURI: String = "",
        rulingsURI: String = "",
        relatedURIs: RelatedURIs = RelatedURIs(),
        prices: Prices = Prices(),
        purchaseURIs: PurchaseURIs = PurchaseURIs(),
        allParts: [RelatedCardObject] = [],
        reserved: Bool = false,
        legalities: [String: String] = [:]
    ) {
        self.id = id
        self.oracleID = oracleID
        self.name = name
        self.releasedAt = releasedAt
        self.imageStatus = imageStatus
        self.imageURIs = imageURIs
        self.manaCost = manaCost
        self.cmc = cmc
        self.colors = colors
        self.colorIdentity = colorIdentity
        self.colorIndicator = colorIndicator
        self.producedMana = producedMana
        self.typeLine = typeLine
        self.oracleText = oracleText
        self.keywords = keywords
        self.toughness = toughness
        self.power = power
        self.loyalty = loyalty
        self.defense = defense
        self.layout = layout
        self.cardFaces = cardFaces
        self.rarity = rarity
        self.flavorText = flavorText
        self.finishes = finishes
        self.set = set
        self.setName = setName
        self.artist = artist
        self.collectorNumber = collectorNumber
        self.edhrecRank = edhrecRank
        self.scryfallURI = scryfallURI
        self.rulingsURI = rulingsURI
        self.relatedURIs = relatedURIs
        self.prices = prices
        self.purchaseURIs = purchaseURIs
        self.allParts = allParts
        self.reserved = reserved
        self.legalities = legalities
    }
}

// MARK: Types used in Card

struct RelatedCardObject: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var uri: String
    /// relationship type: "token", "meld_part", "meld_result", "combo_piece"
    var component: String

    init(id: String = "", name: String = "", uri: String = "", component: String = "") {
        self.id = id
        self.name = name
        self.uri = uri
        self.component = component
    }
}

struct ImageURIs: Codable, Hashable {
    var small: String
    var normal: String
    var large: String
    var png: String
    var artCrop: String
    var borderCrop: String

    init(small: String = "", normal: String = "", large: String = "", png: String = "", artCrop: String = "", borderCrop: String = "") {
        self.small = small
        self.normal = normal
        self.large = large
        self.png = png
        self.artCrop = artCrop
        self.borderCrop = borderCrop
    }
}

struct CardFace: Codable, Hashable, Identifiable {
    var id: String
    var oracleID: String
    var name: String
    var layout: String
    var imageURIs: ImageURIs

    /// text
    var typeLine: String
    var oracleText: String
    var flavorText: String
    var keywords: [String]

    /// stats
    var toughness: String
    var power: String
    var loyalty: String
    var defense: String

    /// mana
    var manaCost: String
    var cmc: Double

    /// colours
    var colors: [String]
    var colorIndicator: [String]
    var producedMana: [String]

    init(
        id: String = UUID().uuidString,
        oracleID: String = "",
        name: String = "",
        layout: String = "",
        imageURIs: ImageURIs = ImageURIs(),
        typeLine: String = "",
        oracleText: String = "",
        flavorText: String = "",
        keywords: [String] = [],
        toughness: String = "",
        power: String = "",
        loyalty: String = "",
        defense: String = "",
        manaCost: String = "",
        cmc: Double = 0.0,
        colors: [String] = [],
        colorIndicator: [String] = [],
        producedMana: [String] = []
    ) {
        self.id = id
        self.oracleID = oracleID
        self.name = name
        self.layout = layout
        self.imageURIs = imageURIs
        self.typeLine = typeLine
        self.oracleText = oracleText
        self.flavorText = flavorText
        self.keywords = keywords
        self.toughness = toughness
        self.power = power
        self.loyalty = loyalty
        self.defense = defense
        self.manaCost = manaCost
        self.cmc = cmc
        self.colors = colors
        self.colorIndicator = colorIndicator
        self.producedMana = producedMana
    }
}

struct Prices: Codable, Hashable {
    var usd: String
    var usdFoil: String
    var usdEtched: String
    var eur: String
    var eurFoil: String
    var tix: String

    init(usd: String = "", usdFoil: String = "", usdEtched: String = "", eur: String = "", eurFoil: String = "", tix: String = "") {
        self.usd = usd
        self.usdFoil = usdFoil
        self.usdEtched = usdEtched
        self.eur = eur
        self.eurFoil = eurFoil
        self.tix = tix
    }
}

struct PurchaseURIs: Codable, Hashable {
    var tcgplayer: String
    var cardmarket: String
    var cardhoarder: String

    init(tcgplayer: String = "", cardmarket: String = "", cardhoarder: String = "") {
        self.tcgplayer = tcgplayer
        self.cardmarket = cardmarket
        self.cardhoarder = cardhoarder
    }
}

struct RelatedURIs: Codable, Hashable {
    var edhrec: String
    var gatherer: String
    var tcgplayerInfiniteDecks: String
    var tcgplayerInfiniteArticles: String

    init(edhrec: String = "", gatherer: String = "", tcgplayerInfiniteDecks: String = "", tcgplayerInfiniteArticles: String = "") {
        self.edhrec = edhrec
        self.gatherer = gatherer
        self.tcgplayerInfiniteDecks = tcgplayerInfiniteDecks
        self.tcgplayerInfiniteArticles = tcgplayerInfiniteArticles
    }
}
