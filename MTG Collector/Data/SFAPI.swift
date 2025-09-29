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
    static func JSONtoModel(card: CardJSON) -> Card {
        let newCard = Card(
            id: card.id,
            oracleID: card.oracleID,
            name: card.name,
            releasedAt: card.releasedAt,
            imageStatus: card.imageStatus,
            imageURIs: ImageURIs(
                small: card.imageURIs!.small,
                normal: card.imageURIs!.normal,
                large: card.imageURIs!.large,
                png: card.imageURIs!.png,
                artCrop: card.imageURIs!.artCrop,
                borderCrop: card.imageURIs!.borderCrop
            ),
            manaCost: card.manaCost,
            cmc: card.cmc,
            colors: card.colors,
            colorIdentity: card.colorIdentity,
            colorIndicator: card.colorIndicator,
            typeLine: card.typeLine,
            oracleText: card.oracleText,
            keywords: card.keywords,
            toughness: card.toughness,
            power: card.power,
            loyalty: card.loyalty,
            defense: card.defense,
            layout: card.layout,
            // map to return array
            cardFaces: card.cardFaces?.map { face in
                CardFace(
                    id: face.id,
                    oracleID: face.oracleID,
                    name: face.name,
                    layout: face.layout,
                    imageURIs: ImageURIs(
                        small: face.imageURIs?.small,
                        normal: face.imageURIs?.normal,
                        large: face.imageURIs?.large,
                        png: face.imageURIs?.png,
                        artCrop: face.imageURIs?.artCrop,
                        borderCrop: face.imageURIs?.borderCrop
                    ),
                    typeLine: face.typeLine,
                    oracleText: face.oracleText,
                    keywords: face.keywords,
                    toughness: face.toughness,
                    power: face.power,
                    loyalty: face.loyalty,
                    defense: face.defense,
                    manaCost: face.manaCost,
                    cmc: face.cmc,
                    colors: face.colors,
                    colorIndicator: face.colorIndicator
                )
            },
            rarity: card.rarity,
            flavorText: card.flavorText,
            finishes: card.finishes,
            set: card.set,
            prices: Prices(
                usd: card.prices!.usd,
                usdFoil: card.prices!.usdFoil,
                usdEtched: card.prices!.usdEtched
            ),
            purchaseURIs: PurchaseURIs(
                tcgplayer: card.purchaseURIs!.tcgplayer,
                cardmarket: card.purchaseURIs!.cardmarket,
                cardhoarder: card.purchaseURIs!.cardhoarder
            ),
            // msp to return array
            allParts: card.allParts?.map { part in
                RelatedCardObject(
                    id: part.id,
                    name: part.name
                )},
            reserved: card.reserved,
            legalities: card.legalities
        )
        return newCard
    }
    
}
