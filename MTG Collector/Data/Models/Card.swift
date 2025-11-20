//
//  Card.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         The Model for the Cards, converted from CardJSON to this Model to be saved locally

// MARK: Imports

import Foundation
import SwiftUI
import SwiftData

// MARK: Types

@Model
class Card {
    
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
    
    /// text
    var typeLine: String
    var oracleText: String
    var keywords: [String]
    
    /// stats
    var toughness: String
    var power: String
    var loyalty: String
    var defense: String
    
    /// muli face cards
    var layout: String
    var cardFaces: [CardFace]
    
    /// other
    var rarity: String
    var flavorText: String
    var finishes: [String]
    var set: String
    
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
        prices: Prices = Prices(),
        purchaseURIs: PurchaseURIs = PurchaseURIs(),
        allParts: [RelatedCardObject] = [],
        reserved: Bool = false,
        legalities: [String : String] = [:]
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
        self.prices = prices
        self.purchaseURIs = purchaseURIs
        self.allParts = allParts
        self.reserved = reserved
        self.legalities = legalities
    }
}

// MARK: Types used in Card

@Model
class RelatedCardObject {
    var id: String
    var name: String
    var uri: String
    
    init(id: String = "", name: String = "", uri: String) {
        self.id = id
        self.name = name
        self.uri = uri
    }
}

@Model
class ImageURIs {
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

@Model
class CardFace {
    var id: String = UUID().uuidString
    var oracleID: String
    var name: String
    var layout: String
    var imageURIs: ImageURIs
    
    /// text
    var typeLine: String
    var oracleText: String
    var keywords: [String]
    
    /// stats
    var toughness: String
    var power: String
    var loyalty: String
    var defense: String
    
    /// mana
    var manaCost: String
    
    /// mana value
    var cmc: Double
    
    /// colours
    var colors: [String]
    var colorIndicator: [String]
    
    init(oracleID: String = "",
         name: String = "",
         layout: String = "",
         imageURIs: ImageURIs = ImageURIs(),
         typeLine: String = "",
         oracleText: String = "",
         keywords: [String] = [],
         toughness: String = "",
         power: String = "",
         loyalty: String = "",
         defense: String = "",
         manaCost: String = "",
         cmc: Double = 0.0,
         colors: [String] = [],
         colorIndicator: [String] = []
     ) {
        self.oracleID = oracleID
        self.name = name
        self.layout = layout
        self.imageURIs = imageURIs
        self.typeLine = typeLine
        self.oracleText = oracleText
        self.keywords = keywords
        self.toughness = toughness
        self.power = power
        self.loyalty = loyalty
        self.defense = defense
        self.manaCost = manaCost
        self.cmc = cmc
        self.colors = colors
        self.colorIndicator = colorIndicator
    }
}

@Model
class Prices {
    var usd: String
    var usdFoil: String
    var usdEtched: String
    
    init(usd: String = "", usdFoil: String = "", usdEtched: String = "") {
        self.usd = usd
        self.usdFoil = usdFoil
        self.usdEtched = usdEtched
    }
}

@Model
class PurchaseURIs {
    var tcgplayer: String
    var cardmarket: String
    var cardhoarder: String
    
    init(tcgplayer: String = "", cardmarket: String = "", cardhoarder: String = "") {
        self.tcgplayer = tcgplayer
        self.cardmarket = cardmarket
        self.cardhoarder = cardhoarder
    }
}
