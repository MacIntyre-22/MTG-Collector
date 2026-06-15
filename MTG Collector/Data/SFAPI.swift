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

    /// Bulk card lookup via /cards/collection (POST). Accepts up to 75 identifiers per call.
    /// Used by the deck import engine and price refresh. Returns resolved cards + any not found.
    static func fetchCardCollection(identifiers: [CardIdentifierJSON]) async -> (found: [CardJSON], notFound: [CardIdentifierJSON]) {
        guard !identifiers.isEmpty, let url = URL(string: "https://api.scryfall.com/cards/collection") else {
            return ([], [])
        }
        do {
            var req = request(from: url)
            req.httpMethod = "POST"
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = try JSONEncoder().encode(["identifiers": Array(identifiers.prefix(75))])

            let (data, _) = try await URLSession.shared.data(for: req)
            let result = try JSONDecoder().decode(ScryfallCollectionData.self, from: data)
            return (result.data, result.notFound ?? [])
        } catch {
            return ([], identifiers)
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
    /// Now that the nested types are Codable structs (not @Model), this is a flat,
    /// nil-coalescing mapping. No SwiftData objects are created here.
    static func JSONtoModel(json: CardJSON) -> Card {
        return Card(
            id: json.id ?? "",
            oracleID: json.oracleID ?? "",
            name: json.name,
            releasedAt: json.releasedAt ?? "",
            imageStatus: json.imageStatus ?? "",
            imageURIs: mapImageURIs(json.imageURIs),
            manaCost: json.manaCost ?? "",
            cmc: json.cmc ?? 0.0,
            colors: json.colors ?? [],
            colorIdentity: json.colorIdentity ?? [],
            colorIndicator: json.colorIndicator ?? [],
            producedMana: json.producedMana ?? [],
            typeLine: json.typeLine ?? "",
            oracleText: json.oracleText ?? "",
            keywords: json.keywords ?? [],
            toughness: json.toughness ?? "",
            power: json.power ?? "",
            loyalty: json.loyalty ?? "",
            defense: json.defense ?? "",
            layout: json.layout ?? "",
            cardFaces: (json.cardFaces ?? []).map(mapCardFace),
            rarity: json.rarity ?? "",
            flavorText: json.flavorText ?? "",
            finishes: json.finishes ?? [],
            set: json.set ?? "",
            setName: json.setName ?? "",
            artist: json.artist ?? "",
            collectorNumber: json.collectorNumber ?? "",
            edhrecRank: json.edhrecRank ?? 0,
            scryfallURI: json.scryfallURI ?? "",
            rulingsURI: json.rulingsURI ?? "",
            relatedURIs: mapRelatedURIs(json.relatedURIs),
            prices: mapPrices(json.prices),
            purchaseURIs: mapPurchaseURIs(json.purchaseURIs),
            allParts: (json.allParts ?? []).map {
                RelatedCardObject(id: $0.id ?? "", name: $0.name ?? "", uri: $0.uri ?? "", component: $0.component ?? "")
            },
            reserved: json.reserved,
            legalities: json.legalities ?? [:]
        )
    }

    // MARK: Nested mappers

    private static func mapImageURIs(_ j: ImageURIsJSON?) -> ImageURIs {
        ImageURIs(
            small: j?.small ?? "",
            normal: j?.normal ?? "",
            large: j?.large ?? "",
            png: j?.png ?? "",
            artCrop: j?.artCrop ?? "",
            borderCrop: j?.borderCrop ?? ""
        )
    }

    private static func mapPrices(_ j: PricesJSON?) -> Prices {
        Prices(
            usd: j?.usd ?? "",
            usdFoil: j?.usdFoil ?? "",
            usdEtched: j?.usdEtched ?? "",
            eur: j?.eur ?? "",
            eurFoil: j?.eurFoil ?? "",
            tix: j?.tix ?? ""
        )
    }

    private static func mapPurchaseURIs(_ j: PurchaseURIsJSON?) -> PurchaseURIs {
        PurchaseURIs(
            tcgplayer: j?.tcgplayer ?? "",
            cardmarket: j?.cardmarket ?? "",
            cardhoarder: j?.cardhoarder ?? ""
        )
    }

    private static func mapRelatedURIs(_ j: RelatedURIsJSON?) -> RelatedURIs {
        RelatedURIs(
            edhrec: j?.edhrec ?? "",
            gatherer: j?.gatherer ?? "",
            tcgplayerInfiniteDecks: j?.tcgplayerInfiniteDecks ?? "",
            tcgplayerInfiniteArticles: j?.tcgplayerInfiniteArticles ?? ""
        )
    }

    private static func mapCardFace(_ face: CardFaceJSON) -> CardFace {
        CardFace(
            oracleID: face.oracleID ?? "",
            name: face.name,
            layout: face.layout ?? "",
            imageURIs: mapImageURIs(face.imageURIs),
            typeLine: face.typeLine ?? "",
            oracleText: face.oracleText ?? "",
            flavorText: face.flavorText ?? "",
            keywords: face.keywords ?? [],
            toughness: face.toughness ?? "",
            power: face.power ?? "",
            loyalty: face.loyalty ?? "",
            defense: face.defense ?? "",
            manaCost: face.manaCost ?? "",
            cmc: face.cmc ?? 0.0,
            colors: face.colors ?? [],
            colorIndicator: face.colorIndicator ?? [],
            producedMana: face.producedMana ?? []
        )
    }

}
