//
//  SFData.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
struct ScryfallSetData: Decodable {
    var data: [SetJSON]
}

struct SetJSON: Codable {
    var id: String?
    var name: String?
    var releaseDate: String?
    var type: String?
    var cardCount: Int?
    var iconURI: String?
    var searchURI: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case releaseDate = "released_at"
        case type
        case cardCount = "card_count"
        case iconURI = "icon_svg_uri"
        case searchURI = "search_uri"
    }
}

struct ScryfallCardData: Decodable {
    var data: [CardJSON]
}

struct CardJSON: Codable, Identifiable {
    var id: String?
    var oracleID: String?
    var name: String
    var releasedAt: String?
    var imageStatus: String?
    var imageURIs: ImageURIsJSON?

    // MANA
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

    // Multi face cards
    var layout: String?
    var cardFaces: [CardFaceJSON]?

    // other
    var rarity: String?
    var flavorText: String?
    var finishes: [String]?
    var setId: String?

    var prices: PricesJSON?
    var purchaseURIs: PurchaseURIsJSON?
    var allParts: [RelatedCardObjectJSON]?
    var reserved: Bool
    var legalities: LegalitiesJSON?

    enum CodingKeys: String, CodingKey {
        case id
        case oracleID = "oracle_id"
        case name
        case releasedAt = "released_at"
        case imageStatus = "image_status"
        case imageURIs = "image_uris"

        case manaCost = "mana_cost"
        case cmc
        case colors
        case colorIdentity = "color_identity"
        case colorIndicator = "color_indicator"

        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case keywords

        case toughness
        case power
        case loyalty
        case defense

        case layout
        case cardFaces = "card_faces"

        case rarity
        case flavorText = "flavor_text"
        case finishes
        case setId = "set_id"

        case prices
        case purchaseURIs = "purchase_uris"
        case allParts = "all_parts"
        case reserved
        case legalities
    }
}

struct ImageURIsJSON: Codable {
    var small: String?
    var normal: String?
    var large: String?
    var png: String?
    var artCrop: String?
    var borderCrop: String?

    enum CodingKeys: String, CodingKey {
        case small, normal, large, png
        case artCrop = "art_crop"
        case borderCrop = "border_crop"
    }
}

struct PricesJSON: Codable {
    var usd: String?
    var usdFoil: String?
    var usdEtched: String?

    enum CodingKeys: String, CodingKey {
        case usd
        case usdFoil = "usd_foil"
        case usdEtched = "usd_etched"
    }
}

struct PurchaseURIsJSON: Codable {
    var tcgplayer: String?
    var cardmarket: String?
    var cardhoarder: String?
}

struct CardFaceJSON: Codable {
    var name: String?
    var manaCost: String?
    var typeLine: String?
    var oracleText: String?
    var colors: [String]?
    var power: String?
    var toughness: String?
    var loyalty: String?

    enum CodingKeys: String, CodingKey {
        case name
        case manaCost = "mana_cost"
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case colors
        case power
        case toughness
        case loyalty
    }
}

struct RelatedCardObjectJSON: Codable {
    var id: String?
    var name: String?
}

struct LegalitiesJSON: Codable {
    var standard: String?
    var future: String?
    var historic: String?
    var timeless: String?
    var gladiator: String?
    var pioneer: String?
    var modern: String?
    var legacy: String?
    var pauper: String?
    var vintage: String?
    var penny: String?
    var commander: String?
    var oathbreaker: String?
    var standardBrawl: String?
    var brawl: String?
    var alchemy: String?
    var pauperCommander: String?
    var duel: String?
    var oldschool: String?
    var premodern: String?
    var predh: String?

    enum CodingKeys: String, CodingKey {
        case standard, future, historic, timeless, gladiator, pioneer, modern, legacy, pauper, vintage, penny, commander, oathbreaker
        case standardBrawl = "standardbrawl"
        case brawl, alchemy
        case pauperCommander = "paupercommander"
        case duel, oldschool, premodern, predh
    }
}

