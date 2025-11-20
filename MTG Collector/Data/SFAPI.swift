//
//  SFAPI.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
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
        do {
            /// build url using the CardFilters
            let url = buildSearchURL(filters: filters)!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let fetchResults = try decoder.decode(ScryfallCardData.self, from: data)
            return fetchResults.data
        } catch {
            print("Error with SFAPI.fetchCardData - \(error)")
            return [] 
        }
    }
    
    /// Card Data by set query, for home suggestions
    /// for random collections
    static func fetchCardQuery(query: String, shuffle: Bool = true) async -> [CardJSON] {
        do {
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let fetchResults = try decoder.decode(ScryfallCardData.self, from: data)
            
            // shuffle these cards so that the output is never the same
            if shuffle {
                return fetchResults.data.shuffled()
            } else {
                return fetchResults.data
            }
        } catch {
            print("Error with SFAPI.fetchCardQuery - \(error)")
            return []
        }
    }
    
    
    /// Card Data by ID
    static func fetchCardId(id: String) async -> CardJSON? {
        do {
            if let url = URL(string: "https://api.scryfall.com/cards/\(id)") {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let fetchResults = try decoder.decode(CardJSON.self, from: data)
                return fetchResults
            }else {
                return nil
            }
        } catch {
            print("Error with SFAPI.fecthCardId - \(error)")
            return nil
        }
    }
    
    /// Card Data by URI
    /// some objects return a uri right for the object
    /// can return nil
    static func fetchCardURI(uri: String) async -> CardJSON? {
        do {
            if let url = URL(string: uri) {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoder = JSONDecoder()
                let fetchResults = try decoder.decode(CardJSON.self, from: data)
                return fetchResults
            }else {
                return nil
            }
        } catch {
            print("Error with SFAPI.fetchCardURI - \(error)")
            return nil
        }
    }
    
    /// Set Data
    /// fetch set data
    static func fetchSetData() async -> [SetJSON] {
        do {
            let url = URL(string: "https://api.scryfall.com/sets")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let fetchResults = try decoder.decode(ScryfallSetData.self, from: data)
            return fetchResults.data
        } catch {
            print("Error with SFAPI.fetchSetData - \(error)")
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
