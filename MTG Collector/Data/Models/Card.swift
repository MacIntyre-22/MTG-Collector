//
//  Card.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
import Foundation
import SwiftUI
import SwiftData

// MARK: Scryfall Card Info
@Model
class Card {
    var id: String?
    var oracleID: String?
    var name: String
    var releasedAt: String?
    var imageStatus: String?
    var imageURIs: ImageURIs?
    
    // MANA
    // mana cost in sysmbols: {W}, {B}
    var manaCost: String?
    var cmc: Double?
    var colors: [String]?
    var colorIdentity: [String]?
    var colorIndicator: [String]?
    
    // text
    var typeLine: String?
    var oracleText: String?
    var keywords: [String]?
    
    // stats
    var toughness: String?
    var power: String?
    var loyalty: String?
    var defense: String?
    
    // Muli face cards
    var layout: String?
    var cardFaces: [CardFace]?
    
    // other
    var rarity: String?
    var flavorText: String?
    var finishes: [String]?
    var set: String?
    
    var prices: Prices?
    var purchaseURIs: PurchaseURIs?
    var allParts: [RelatedCardObject]?
    var reserved: Bool
    var legalities: [String: String]?
 
    init(id: String? = nil, oracleID: String? = nil, name: String, releasedAt: String? = nil, imageStatus: String? = nil, imageURIs: ImageURIs? = nil, manaCost: String? = nil, cmc: Double? = nil, colors: [String]? = nil, colorIdentity: [String]? = nil, colorIndicator: [String]? = nil, typeLine: String? = nil, oracleText: String? = nil, keywords: [String]? = nil, toughness: String? = nil, power: String? = nil, loyalty: String? = nil, defense: String? = nil, layout: String? = nil, cardFaces: [CardFace]? = nil, rarity: String? = nil, flavorText: String? = nil, finishes: [String]? = nil, set: String? = nil, prices: Prices? = nil, purchaseURIs: PurchaseURIs? = nil, allParts: [RelatedCardObject]? = nil, reserved: Bool, legalities: [String : String]? = nil) {
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

@Model
class RelatedCardObject {
    var id: String?
    var name: String?
    
    init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

// images model
@Model
class ImageURIs {
    var small: String?
    var normal: String?
    var large: String?
    var png: String?
    var artCrop: String?
    var borderCrop: String?

    init(small: String? = nil, normal: String? = nil, large: String? = nil, png: String? = nil, artCrop: String? = nil, borderCrop: String? = nil) {
        self.small = small
        self.normal = normal
        self.large = large
        self.png = png
        self.artCrop = artCrop
        self.borderCrop = borderCrop
    }
}

// card face model
@Model
class CardFace {
    var id: String?
    var oracleID: String?
    var name: String
    var layout: String?
    var imageURIs: ImageURIs?
    
    // text
    var typeLine: String?
    var oracleText: String?
    var keywords: [String]?
    
    // stats
    var toughness: String?
    var power: String?
    var loyalty: String?
    var defense: String?
    
    // MANA
    // mana cost in sysmbols: {W}, {B}
    var manaCost: String?
    // mana value
    var cmc: String?
    // colours
    var colors: [String]?
    var colorIndicator: [String]?
    
    init(id: String? = nil, oracleID: String? = nil, name: String, layout: String? = nil, imageURIs: ImageURIs? = nil, typeLine: String? = nil, oracleText: String? = nil, keywords: [String]? = nil, toughness: String? = nil, power: String? = nil, loyalty: String? = nil, defense: String? = nil, manaCost: String? = nil, cmc: String? = nil, colors: [String]? = nil, colorIndicator: [String]? = nil) {
        self.id = id
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

// prices model
@Model
class Prices {
    var usd: String?
    var usdFoil: String?
    var usdEtched: String?
    
    init(usd: String? = nil, usdFoil: String? = nil, usdEtched: String? = nil) {
        self.usd = usd
        self.usdFoil = usdFoil
        self.usdEtched = usdEtched
    }
}


// purchase uri model
@Model
class PurchaseURIs {
    var tcgplayer: String?
    var cardmarket: String?
    var cardhoarder: String?
    var mtgo: String?
    var magiceden: String?
    
    init(tcgplayer: String? = nil, cardmarket: String? = nil, cardhoarder: String? = nil, mtgo: String? = nil, magiceden: String? = nil) {
        self.tcgplayer = tcgplayer
        self.cardmarket = cardmarket
        self.cardhoarder = cardhoarder
        self.mtgo = mtgo
        self.magiceden = magiceden
    }
    
}

//// legalities
//@Model
//class Legalities {
//    var standard: String?
//    var future: String?
//    var historic: String?
//    var timeless: String?
//    var gladiator: String?
//    var pioneer: String?
//    var modern: String?
//    var legacy: String?
//    var pauper: String?
//    var vintage: String?
//    var penny: String?
//    var commander: String?
//    var oathbreaker: String?
//    var standardBrawl: String?
//    var brawl: String?
//    var alchemy: String?
//    var pauperCommander: String?
//    var duel: String?
//    var oldschool: String?
//    var premodern: String?
//    var predh: String?
//    
//    init(standard: String? = nil, future: String? = nil, historic: String? = nil, timeless: String? = nil, gladiator: String? = nil, pioneer: String? = nil, modern: String? = nil, legacy: String? = nil, pauper: String? = nil, vintage: String? = nil, penny: String? = nil, commander: String? = nil, oathbreaker: String? = nil, standardBrawl: String? = nil, brawl: String? = nil, alchemy: String? = nil, pauperCommander: String? = nil, duel: String? = nil, oldschool: String? = nil, premodern: String? = nil, predh: String? = nil) {
//        self.standard = standard
//        self.future = future
//        self.historic = historic
//        self.timeless = timeless
//        self.gladiator = gladiator
//        self.pioneer = pioneer
//        self.modern = modern
//        self.legacy = legacy
//        self.pauper = pauper
//        self.vintage = vintage
//        self.penny = penny
//        self.commander = commander
//        self.oathbreaker = oathbreaker
//        self.standardBrawl = standardBrawl
//        self.brawl = brawl
//        self.alchemy = alchemy
//        self.pauperCommander = pauperCommander
//        self.duel = duel
//        self.oldschool = oldschool
//        self.premodern = premodern
//        self.predh = predh
//    }
//}
