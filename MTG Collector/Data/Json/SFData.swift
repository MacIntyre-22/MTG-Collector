//
//  SFData.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

// MARK: Scryfall Set Data
// for pulling sets only
struct ScryfallSetData: Decodable {
    var data: [SetJSON]
}

// MARK: Set Object Json
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

// MARK: Scryfall Data
// for search
struct ScryfallCardData: Decodable {
    var data: [CardJSON]
}

// MARK: Card Object JSON
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
    var set: String?

    var prices: PricesJSON?
    var purchaseURIs: PurchaseURIsJSON?
    var allParts: [RelatedCardObjectJSON]?
    var reserved: Bool
    var legalities: [String: String]?

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
        case set

        case prices
        case purchaseURIs = "purchase_uris"
        case allParts = "all_parts"
        case reserved
        case legalities
    }
}

// MARK: Image URIs Object JSON
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

// MARK: Prices Object JSON
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

// MARK: Purchase URIs Object JSON
struct PurchaseURIsJSON: Codable {
    var tcgplayer: String?
    var cardmarket: String?
    var cardhoarder: String?
}

// MARK: Card Face Object JSON
struct CardFaceJSON: Codable, Identifiable {
    var id: String?
    var oracleID: String?
    var name: String
    var layout: String?
    var imageURIs: ImageURIsJSON?
    
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
    var manaCost: String?
    // mana value
    var cmc: Double?
    // colours
    var colors: [String]?
    var colorIndicator: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case oracleID = "oracle_id"
        case name
        case layout
        case imageURIs = "image_uris"
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case keywords
        
        case toughness
        case power
        case loyalty
        case defense
        
        case manaCost = "mana_cost"
        case cmc
        case colors
        case colorIndicator = "color_indicator"
        
    }
}

// MARK: Related Card Object JSON
struct RelatedCardObjectJSON: Codable {
    var id: String?
    var name: String?
}
