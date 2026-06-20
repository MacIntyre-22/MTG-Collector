//
//  CurrencyRates.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Live foreign-exchange rates (USD base) for the price display layer. Collection values are
//      stored once in canonical USD; every currency shown to the user is a conversion of that, so
//      adding a currency only needs a rate here — no stored data changes. Rates are fetched from a
//      free, no-key endpoint, cached to disk, and refreshed at most once a day. A static fallback
//      table seeds first launch and covers offline use, so conversion always works.
//  External Types:
//      CurrencyFX
//

// MARK: Imports

import Foundation

// MARK: Rates

/// Thread-safe singleton holding "units of currency per 1 USD". Reads are lock-guarded so the
/// non-isolated `CurrencyFX` helpers (called from views and StatsUpdater) can convert anywhere.
final class CurrencyRates: @unchecked Sendable {

    static let shared = CurrencyRates()

    // MARK: Stored

    private let lock = NSLock()
    private var _ratesPerUSD: [String: Double]
    private var _lastFetched: Date?

    /// Free, no-key daily FX feed (USD base). Mirrors the open exchange-rate API shape.
    private let endpoint = URL(string: "https://open.er-api.com/v6/latest/USD")!
    private let ratesKey = "fx.ratesPerUSD"
    private let dateKey  = "fx.lastFetched"

    /// Seed rates — approximate, used until the first live fetch lands and whenever offline.
    private static let fallback: [String: Double] = [
        "usd": 1.0, "cad": 1.37, "eur": 0.92, "gbp": 0.79, "aud": 1.52, "jpy": 157.0
    ]

    private init() {
        let saved = (UserDefaults.standard.data(forKey: ratesKey))
            .flatMap { try? JSONDecoder().decode([String: Double].self, from: $0) }
        _ratesPerUSD = saved ?? Self.fallback
        _ratesPerUSD["usd"] = 1.0
        _lastFetched = UserDefaults.standard.object(forKey: dateKey) as? Date
    }

    // MARK: Reads

    /// Units of `code` per 1 USD, or nil if we don't carry that currency.
    func rate(for code: String) -> Double? {
        lock.withLock { _ratesPerUSD[code.lowercased()] }
    }

    var lastFetched: Date? { lock.withLock { _lastFetched } }

    // MARK: Refresh

    /// Fetch fresh rates if the cache is older than `maxAge` (default 24h). Safe to call on launch.
    func refreshIfStale(maxAge: TimeInterval = 86_400) async {
        if let last = lastFetched, Date().timeIntervalSince(last) < maxAge { return }
        await refresh()
    }

    /// Fetch the latest rates; on any failure the existing cache/fallback is kept untouched.
    func refresh() async {
        var request = URLRequest(url: endpoint)
        request.setValue(AppHTTP.userAgent, forHTTPHeaderField: "User-Agent")
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(Response.self, from: data)
            guard decoded.result == "success" else { return }

            var map: [String: Double] = [:]
            for (key, value) in decoded.rates where value > 0 { map[key.lowercased()] = value }
            map["usd"] = 1.0
            guard map.count > 1 else { return }

            lock.withLock {
                _ratesPerUSD = map
                _lastFetched = Date()
            }
            if let data = try? JSONEncoder().encode(map) {
                UserDefaults.standard.set(data, forKey: ratesKey)
            }
            UserDefaults.standard.set(Date(), forKey: dateKey)
        } catch {
            // Keep the last good rates / fallback — conversion stays available.
        }
    }

    // MARK: Decoding

    private struct Response: Decodable {
        let result: String
        let rates: [String: Double]

        enum CodingKeys: String, CodingKey {
            case result
            case rates = "rates"
        }
    }
}
