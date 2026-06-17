//
//  Currency.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Display currency selection. Scryfall provides USD, EUR and MTGO tix prices; CAD reuses the
//      USD value (no live FX) so the existing CAD display keeps working. One place formats prices
//      and picks the right stored value, driven by Settings.currency via the `appCurrency`
//      environment so every price display stays consistent.
//  External Types:
//      CollectionStats, Prices
//

// MARK: Imports

import SwiftUI

// MARK: Currency

enum AppCurrency: String, CaseIterable, Identifiable {
    case cad
    case usd
    case eur
    case tix

    var id: String { rawValue }

    var label: String {
        switch self {
        case .cad: return "CAD ($)"
        case .usd: return "USD ($)"
        case .eur: return "EUR (€)"
        case .tix: return "MTGO Tix"
        }
    }

    /// Stored collection total for this currency (CAD reuses the USD total).
    func total(_ stats: CollectionStats?) -> Double {
        guard let stats else { return 0 }
        switch self {
        case .cad, .usd: return stats.totalPriceUSD
        case .eur: return stats.totalPriceEUR
        case .tix: return stats.totalPriceTix
        }
    }

    /// Single-card price for this currency (CAD reuses the USD price).
    func value(_ prices: Prices) -> Double {
        switch self {
        case .cad, .usd: return Double(prices.usd) ?? 0
        case .eur: return Double(prices.eur) ?? 0
        case .tix: return Double(prices.tix) ?? 0
        }
    }

    /// Format a numeric value in this currency.
    func format(_ value: Double) -> String {
        switch self {
        case .tix: return "\(value.formatted(.number.precision(.fractionLength(2)))) tix"
        case .cad: return value.formatted(.currency(code: "CAD"))
        case .usd: return value.formatted(.currency(code: "USD"))
        case .eur: return value.formatted(.currency(code: "EUR"))
        }
    }

    /// Format a string price (e.g. a Scryfall "1.23") in this currency.
    func format(_ string: String) -> String {
        format(Double(string) ?? 0)
    }

    /// Card finish prices available for this currency (CAD/USD: base/foil/etched; EUR: base/foil;
    /// Tix: a single base price). Used to build the card price pills.
    func cardPrices(_ p: Prices) -> [(finish: String, price: String)] {
        switch self {
        case .cad, .usd:
            var r: [(String, String)] = []
            if !p.usd.isEmpty { r.append(("Base", p.usd)) }
            if !p.usdFoil.isEmpty { r.append(("Foil", p.usdFoil)) }
            if !p.usdEtched.isEmpty { r.append(("Etched", p.usdEtched)) }
            return r
        case .eur:
            var r: [(String, String)] = []
            if !p.eur.isEmpty { r.append(("Base", p.eur)) }
            if !p.eurFoil.isEmpty { r.append(("Foil", p.eurFoil)) }
            return r
        case .tix:
            return p.tix.isEmpty ? [] : [("Base", p.tix)]
        }
    }
}

// MARK: Environment

private struct AppCurrencyKey: EnvironmentKey {
    static let defaultValue: AppCurrency = .cad
}

extension EnvironmentValues {
    /// The user's selected display currency, injected at the app root from Settings.
    var appCurrency: AppCurrency {
        get { self[AppCurrencyKey.self] }
        set { self[AppCurrencyKey.self] = newValue }
    }
}
