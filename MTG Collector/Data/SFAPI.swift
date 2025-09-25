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
    
    // MARK:
    
}
