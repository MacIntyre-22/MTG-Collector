//
//  SFAPI.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-21.
//

import Foundation

struct SFAPI {
    
    // build url
    static func buildSearchURL(filters: CardFilters) -> URL? {
        let query = buildQuery(from: filters)
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://api.scryfall.com/cards/search?q=\(encoded)")
    }
    
    // MARK: Card Data
    // static fetch data
    static func fetchCardData(filters: CardFilters) async -> [CardJSON] {
        do {
            let url = buildSearchURL(filters: filters)!
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let fetchResults = try decoder.decode(ScryfallCardData.self, from: data)
            return fetchResults.data
        } catch {
            print("There was an error - \(error)")
            return [] 
        }
    }
    
    // MARK: Set Data
    // fetch set data
    static func fetchSetData() async -> [SetJSON] {
        do {
            let url = URL(string: "https://api.scryfall.com/sets")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let fetchResults = try decoder.decode(ScryfallSetData.self, from: data)
            return fetchResults.data
        } catch {
            print("There was an error - \(error)")
            return []
        }
    }
    
    // MARK: Convert JSON card to model
    static func JSONtoModel(json: CardJSON) -> Card {
        return Card(
                id: json.id ?? "",
                oracleID: json.oracleID ?? "",
                name: json.name ?? "",
                releasedAt: json.releasedAt ?? "",
                imageStatus: json.imageStatus ?? "",
                imageURIs: ImageURIs(
                    small: json.imageURIs?.small ?? "",
                    normal: json.imageURIs?.normal ?? "",
                    large: json.imageURIs?.large ?? "",
                    png: json.imageURIs?.png ?? "",
                    artCrop: json.imageURIs?.artCrop ?? "",
                    borderCrop: json.imageURIs?.borderCrop ?? ""
                ),
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
                cardFaces: [CardFace] = (json.cardFaces ?? []).map { face in
                    CardFace(
                        id: face.id ?? "",
                        oracleID: face.oracleID ?? "",
                        name: face.name ?? "",
                        layout: face.layout ?? "",
                        imageURIs: ImageURIs(
                            small: face.imageURIs?.small ?? "",
                            normal: face.imageURIs?.normal ?? "",
                            large: face.imageURIs?.large ?? "",
                            png: face.imageURIs?.png ?? "",
                            artCrop: face.imageURIs?.artCrop ?? "",
                            borderCrop: face.imageURIs?.borderCrop ?? ""
                        ),
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
                },
                rarity: json.rarity ?? "",
                flavorText: json.flavorText ?? "",
                finishes: json.finishes ?? [],
                set: json.set ?? "",
                prices: Prices(
                    usd: json.prices?.usd ?? "",
                    usdFoil: json.prices?.usdFoil ?? "",
                    usdEtched: json.prices?.usdEtched ?? ""
                ),
                purchaseURIs: PurchaseURIs(
                    tcgplayer: json.purchaseURIs?.tcgplayer ?? "",
                    cardmarket: json.purchaseURIs?.cardmarket ?? "",
                    cardhoarder: json.purchaseURIs?.cardhoarder ?? ""
                ),
                // map card parts
                allParts: [RelatedCardObject] = (json.allParts ?? []).map {
                    RelatedCardObject(id: $0.id ?? "", name: $0.name ?? "")
                },
                reserved: json.reserved ?? false,
                legalities: json.legalities ?? [:]
            )
    }
    
}
