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
