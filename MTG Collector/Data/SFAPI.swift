//
//  SFAPI.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2025-09-21.
//  Purpose:
//         Features various functions to make apis calls in different ways for certain data
// External Types:
//         CardJSON, SetJSON, ScryfallCardData, ScryfallSetData, SetInfo, Card

// MARK: Imports

import Foundation
import CoreSpotlight
import UIKit

// MARK: Types

struct SFAPI {

    // MARK: Private Helpers

    private static func request(from url: URL) -> URLRequest {
        var req = URLRequest(url: url)
        req.setValue(AppHTTP.userAgent, forHTTPHeaderField: "User-Agent")
        // Scryfall requires an Accept header on every request (alongside User-Agent).
        req.setValue("application/json", forHTTPHeaderField: "Accept")
        return req
    }

    /// Single choke point for every api.scryfall.com call: wait for a rate-limit slot (≤10/sec),
    /// record it for monitoring, then perform the request. Card art / SVGs / logos load on CDNs and
    /// don't pass through here, so they're never throttled.
    private static func send(_ request: URLRequest) async throws -> Data {
        await ScryfallLimiter.shared.wait()
        RateLimitMonitor.shared.record()
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }

    // MARK: API Functions

    /// Card Data by set query, for home suggestions
    /// for random collections
    static func fetchCardQuery(query: String, shuffle: Bool = true) async -> [CardJSON] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)") else { return [] }
        do {
            let data = try await send(request(from: url))
            let fetchResults = try JSONDecoder().decode(ScryfallCardData.self, from: data)
            return shuffle ? fetchResults.data.shuffled() : fetchResults.data
        } catch {
            return []
        }
    }

    /// Resolve a (possibly mis-OCR'd) card name to a single card via Scryfall's fuzzy match.
    /// Used by the live card scanner. Returns nil if no confident match.
    static func fetchCardNamed(fuzzy name: String) async -> CardJSON? {
        let encoded = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard !encoded.isEmpty,
              let url = URL(string: "https://api.scryfall.com/cards/named?fuzzy=\(encoded)") else {
            return nil
        }
        do {
            let data = try await send(request(from: url))
            return try JSONDecoder().decode(CardJSON.self, from: data)
        } catch {
            return nil
        }
    }

    /// Resolve an exact printing from a set code + collector number (Scryfall `/cards/:code/:number`).
    /// Used by the card scanner when it can read the bottom-line set/collector info. Returns nil if
    /// that exact printing doesn't exist (caller falls back to a fuzzy name match).
    static func fetchCard(set: String, number: String) async -> CardJSON? {
        let code = set.lowercased().addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        let num = number.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        guard !code.isEmpty, !num.isEmpty,
              let url = URL(string: "https://api.scryfall.com/cards/\(code)/\(num)") else { return nil }
        do {
            let data = try await send(request(from: url))
            return try JSONDecoder().decode(CardJSON.self, from: data)
        } catch {
            return nil
        }
    }

    /// Card Data by ID
    static func fetchCardId(id: String) async -> CardJSON? {
        guard let url = URL(string: "https://api.scryfall.com/cards/\(id)") else { return nil }
        do {
            let data = try await send(request(from: url))
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
            let data = try await send(request(from: url))
            return try JSONDecoder().decode(CardJSON.self, from: data)
        } catch {
            return nil
        }
    }

    /// Fetch a card's rulings from its `rulings_uri`. Returns [] on any failure.
    static func fetchRulings(uri: String) async -> [Ruling] {
        guard let url = URL(string: uri) else { return [] }
        do {
            let data = try await send(request(from: url))
            let decoded = try JSONDecoder().decode(RulingsJSON.self, from: data)
            return decoded.data.map {
                Ruling(source: $0.source ?? "", publishedAt: $0.publishedAt ?? "", comment: $0.comment ?? "")
            }
        } catch {
            return []
        }
    }

    /// Set Data
    /// fetch set data
    static func fetchSetData() async -> [SetJSON] {
        guard let url = URL(string: "https://api.scryfall.com/sets") else { return [] }
        do {
            let data = try await send(request(from: url))
            let fetchResults = try JSONDecoder().decode(ScryfallSetData.self, from: data)
            return fetchResults.data
        } catch {
            return []
        }
    }

    /// Search by raw Scryfall query string with explicit sort order/direction.
    /// `order` maps to Scryfall's order param (name, cmc, usd, edhrec, released, color, …).
    static func fetchCards(query: String, order: String = "name", descending: Bool = false) async -> [CardJSON] {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let dir = descending ? "desc" : "asc"
        guard !encoded.isEmpty,
              let url = URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)&order=\(order)&dir=\(dir)") else {
            return []
        }
        do {
            let data = try await send(request(from: url))
            let fetchResults = try JSONDecoder().decode(ScryfallCardData.self, from: data)
            return fetchResults.data
        } catch {
            return []
        }
    }

    /// Every printing of a card (one per set/collector-number variant), newest first. Keyed by the
    /// card's `oracle_id` so split / double-faced names resolve cleanly. Used by the scanner's
    /// printing picker so a user can correct an auto-guessed printing.
    static func fetchPrintings(oracleID: String) async -> [CardJSON] {
        await fetchCards(query: "oracleid:\(oracleID) unique:prints", order: "released", descending: true)
    }

    /// One page of a Scryfall search: the cards plus paging metadata.
    struct CardPage {
        var cards: [CardJSON]
        var totalCards: Int
        var hasMore: Bool
        var nextPage: String?
    }

    /// First page of a search, with total count + next-page link for pagination.
    static func fetchCardsPage(query: String, order: String = "name", descending: Bool = false) async -> CardPage {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let dir = descending ? "desc" : "asc"
        guard !encoded.isEmpty,
              let url = URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)&order=\(order)&dir=\(dir)") else {
            return CardPage(cards: [], totalCards: 0, hasMore: false, nextPage: nil)
        }
        return await fetchPage(url: url)
    }

    /// Fetch a subsequent page from a Scryfall `next_page` URL.
    static func fetchCardsPage(nextPage urlString: String) async -> CardPage {
        guard let url = URL(string: urlString) else {
            return CardPage(cards: [], totalCards: 0, hasMore: false, nextPage: nil)
        }
        return await fetchPage(url: url)
    }

    private static func fetchPage(url: URL) async -> CardPage {
        do {
            let data = try await send(request(from: url))
            let result = try JSONDecoder().decode(ScryfallCardData.self, from: data)
            return CardPage(
                cards: result.data,
                totalCards: result.totalCards ?? result.data.count,
                hasMore: result.hasMore ?? false,
                nextPage: result.nextPage
            )
        } catch {
            // Scryfall returns 404 with an error object when nothing matches → empty page.
            return CardPage(cards: [], totalCards: 0, hasMore: false, nextPage: nil)
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

            let data = try await send(req)
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
