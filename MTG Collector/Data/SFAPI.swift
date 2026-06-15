//
//  SFAPI.swift
//  MTG Collector
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//         Features various functions to make apis calls in different ways for certain data
// External Types:
//         CardFilters, CardJSON, SetJSON, ScryfallCardData, ScrydfallSetData, SetInfo, Card

// MARK: Imports

import Foundation
import CoreSpotlight
import UIKit

// MARK: Types

struct SFAPI {

    // MARK: Private Helpers

    private static func request(from url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.setValue("MTGCollector/1.0 (benmacintyre09@gmail.com)", forHTTPHeaderField: "User-Agent")
        return req
    }

    // MARK: API Functions

    /// URL Builder
    /// build url from filters struct
    static func buildSearchURL(filters: CardFilters) -> URL? {
        let query = buildQuery(from: filters)
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)")
    }

    /// Card Data
    /// querys cards based on CardFilter values
    static func fetchCardData(filters: CardFilters) async -> [CardJSON] {
        guard let url = buildSearchURL(filters: filters) else { return [] }
        do {
            let (data, _) = try await URLSession.shared.data(for: request(from: url))
            let fetchResults = try JSONDecoder().decode(ScryfallCardData.self, from: data)
            return fetchResults.data
        } catch {
            return []
        }
    }

    /// Card Data by set query, for home suggestions
    /// for random collections
    static func fetchCardQuery(query: String, shuffle: Bool = true) async -> [CardJSON] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)") else { return [] }
        do {
            let (data, _) = try await URLSession.shared.data(for: request(from: url))
            let fetchResults = try JSONDecoder().decode(ScryfallCardData.self, from: data)
            return shuffle ? fetchResults.data.shuffled() : fetchResults.data
        } catch {
            return []
        }
    }

    /// Card Data by ID
    static func fetchCardId(id: String) async -> CardJSON? {
        guard let url = URL(string: "https://api.scryfall.com/cards/\(id)") else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(for: request(from: url))
            return try JSONDecoder().decode(CardJSON.self, from: data)
        } catch {
            return nil
        }
    }

    /// Card Data by URI
    /// some objects return a uri right for the object
    /// can return nil
    static func fetchCardURI(uri: String) async -> CardJSON? {
        guard let url = URL(string: uri) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(for: request(from: url))
            return try JSONDecoder().decode(CardJSON.self, from: data)
        } catch {
            return nil
        }
    }

    /// Set Data
    /// fetch set data
    static func fetchSetData() async -> [SetJSON] {
        guard let url = URL(string: "https://api.scryfall.com/sets") else { return [] }
        do {
            let (data, _) = try await URLSession.shared.data(for: request(from: url))
            let fetchResults = try JSONDecoder().decode(ScryfallSetData.self, from: data)
            return fetchResults.data
        } catch {
            return []
        }
    }
    
    // MARK: Conversion Functions
    
    /// Convert JSON set to model
    static func setToModel(json: SetJSON) -> SetInfo {
        return SetInfo(
            code: json.code ?? "",
            name: json.name ?? "",
            releaseDate: json.releaseDate ?? "",
            type: json.type ?? "",
            cardCount: json.cardCount ?? 0,
            iconURI: json.iconURI ?? ""
        )
    }
    
    // MARK: Convert JSON card to model
    static func JSONtoModel(json: CardJSON) -> Card {
        // had to break it up or else it wouldnt run
        
        let tempImageURIs: ImageURIs = ImageURIs(
            small: json.imageURIs?.small ?? "",
            normal: json.imageURIs?.normal ?? "",
            large: json.imageURIs?.large ?? "",
            png: json.imageURIs?.png ?? "",
            artCrop: json.imageURIs?.artCrop ?? "",
            borderCrop: json.imageURIs?.borderCrop ?? ""
        )
        
        let tempCardFaces: [CardFace] = (json.cardFaces ?? []).map { face in
            // had to break it up even more
            let tempFaceImages: ImageURIs = ImageURIs(
                small: face.imageURIs?.small ?? "",
                normal: face.imageURIs?.normal ?? "",
                large: face.imageURIs?.large ?? "",
                png: face.imageURIs?.png ?? "",
                artCrop: face.imageURIs?.artCrop ?? "",
                borderCrop: face.imageURIs?.borderCrop ?? ""
            )
            
            
            return CardFace(
                oracleID: face.oracleID ?? "",
                name: face.name,
                layout: face.layout ?? "",
                imageURIs: tempFaceImages,
                typeLine: face.typeLine ?? "",
                oracleText: face.oracleText ?? "",
                keywords: face.keywords ?? [],
                toughness: face.toughness ?? "",
                power: face.power ?? "",
                loyalty: face.loyalty ?? "",
                defense: face.defense ?? "",
                manaCost: face.manaCost ?? "",
                cmc: face.cmc ?? 0.0,
                colors: face.colors ?? [],
                colorIndicator: face.colorIndicator ?? []
            )
        }
        
        let tempPrices: Prices = Prices(
            usd: json.prices?.usd ?? "",
            usdFoil: json.prices?.usdFoil ?? "",
            usdEtched: json.prices?.usdEtched ?? ""
        )
        
        let tempPurchaseURIs: PurchaseURIs = PurchaseURIs(
            tcgplayer: json.purchaseURIs?.tcgplayer ?? "",
            cardmarket: json.purchaseURIs?.cardmarket ?? "",
            cardhoarder: json.purchaseURIs?.cardhoarder ?? ""
        )
        
        let tempParts: [RelatedCardObject] = (json.allParts ?? []).map {
            RelatedCardObject(id: $0.id ?? "", name: $0.name ?? "", uri: $0.uri ?? "")
        }
        
        
        // build card
        return Card(
                id: json.id ?? "",
                oracleID: json.oracleID ?? "",
                name: json.name,
                releasedAt: json.releasedAt ?? "",
                imageStatus: json.imageStatus ?? "",
                imageURIs: tempImageURIs,
                manaCost: json.manaCost ?? "",
                cmc: json.cmc ?? 0.0,
                colors: json.colors ?? [],
                colorIdentity: json.colorIdentity ?? [],
                colorIndicator: json.colorIndicator ?? [],
                typeLine: json.typeLine ?? "",
                oracleText: json.oracleText ?? "",
                keywords: json.keywords ?? [],
                toughness: json.toughness ?? "",
                power: json.power ?? "",
                loyalty: json.loyalty ?? "",
                defense: json.defense ?? "",
                layout: json.layout ?? "",
                // map card faces
                cardFaces: tempCardFaces,
                rarity: json.rarity ?? "",
                flavorText: json.flavorText ?? "",
                finishes: json.finishes ?? [],
                set: json.set ?? "",
                prices: tempPrices,
                purchaseURIs: tempPurchaseURIs,
                // map card parts
                allParts: tempParts,
                reserved: json.reserved,
                legalities: json.legalities ?? [:]
            )
    }
    
}
