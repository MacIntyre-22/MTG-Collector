//
//  SymbolStore.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Fetches Scryfall's /symbology endpoint and persists a {symbol} → svg_uri map in
//      UserDefaults. Refreshed at most once a week (symbols almost never change). Any code that
//      needs to resolve a symbol string like "{W}" or "{T}" to an SVG URL calls uri(for:).
//

// MARK: Imports

import Foundation

// MARK: Store

enum SymbolStore {

    private static let mapKey  = "symbolURIMap"
    private static let dateKey = "symbolMapDate"
    private static let maxAge: TimeInterval = 7 * 24 * 60 * 60  // weekly

    private static var _map: [String: String]?
    private static var map: [String: String] {
        if let m = _map { return m }
        let m = loadFromDefaults()
        _map = m
        return m
    }

    // MARK: Public API

    static func uri(for symbol: String) -> String? { map[symbol] }

    /// Fetch /symbology and refresh the local map if stale. Safe to call on app launch.
    static func load() async {
        guard needsRefresh() else { return }
        await ScryfallLimiter.shared.wait()   // api.scryfall.com → respect the shared rate limit
        guard let url = URL(string: "https://api.scryfall.com/symbology"),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let response = try? JSONDecoder().decode(SymbologyResponse.self, from: data) else { return }

        var fresh: [String: String] = [:]
        for item in response.data where !item.svgURI.isEmpty {
            fresh[item.symbol] = item.svgURI
        }
        _map = fresh
        if let encoded = try? JSONEncoder().encode(fresh) {
            UserDefaults.standard.set(encoded, forKey: mapKey)
            UserDefaults.standard.set(Date(), forKey: dateKey)
        }
    }

    // MARK: Private

    private static func needsRefresh() -> Bool {
        guard let date = UserDefaults.standard.object(forKey: dateKey) as? Date else { return true }
        return Date().timeIntervalSince(date) > maxAge
    }

    private static func loadFromDefaults() -> [String: String] {
        guard let data = UserDefaults.standard.data(forKey: mapKey),
              let map = try? JSONDecoder().decode([String: String].self, from: data) else { return [:] }
        return map
    }
}

// MARK: Response model

private struct SymbologyResponse: Decodable {
    let data: [SymbolItem]
    struct SymbolItem: Decodable {
        let symbol: String
        let svgURI: String
        enum CodingKeys: String, CodingKey {
            case symbol
            case svgURI = "svg_uri"
        }
    }
}
