//
//  Currency.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Display currency selection and the pricing maths. Collection values are stored once in
//      canonical USD (`AppCurrency.canonicalUSD`, normalising Scryfall's USD/EUR markets); the
//      display layer converts that to the user's currency via live FX (`CurrencyFX`/`CurrencyRates`),
//      so adding a currency is just a rate. MTGO tix is pegged (~$1) and flagged as estimated.
//      Driven by Settings.currency via the `appCurrency` environment for app-wide consistency.
//  External Types:
//      CollectionStats, Prices, CurrencyFX, CurrencyRates
//

// MARK: Imports

import SwiftUI

// MARK: FX

/// Currency conversion via the USD pivot, backed by live rates (`CurrencyRates`) with a static
/// fallback. Collection values are stored once in canonical USD; this turns that into whatever the
/// user wants to see, so adding a currency is just adding a rate.
///
/// MTGO tix has no real FX rate (it's a separate digital economy), so it's pegged at ~1 tix = $1.
/// Any tix figure is therefore an estimate — the UI flags it (see `AppCurrency.isEstimated`).
enum CurrencyFX {

    /// Rough peg: USD per 1 tix. Tix are sold by Wizards at $1 face; secondary value sits a touch
    /// under. There's no live market rate, so this is a deliberate approximation.
    static let usdPerTix = 1.0

    /// Convert an amount between currencies through the USD pivot. Unknown codes pass through.
    static func convert(_ amount: Double, from: String, to: String) -> Double {
        let from = from.lowercased(), to = to.lowercased()
        guard amount != 0, from != to else { return amount }

        // Step 1: bring the amount to USD.
        let usd: Double
        if from == "usd" {
            usd = amount
        } else if from == "tix" {
            usd = amount * usdPerTix
        } else if let rate = CurrencyRates.shared.rate(for: from), rate > 0 {
            usd = amount / rate
        } else {
            return amount   // unknown source currency — leave as-is
        }

        // Step 2: USD → target.
        if to == "usd" { return usd }
        if to == "tix" { return usd / usdPerTix }
        if let rate = CurrencyRates.shared.rate(for: to) { return usd * rate }
        return usd
    }
}

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

    /// The currency code amounts are reported in for this display currency.
    var code: String {
        switch self {
        case .usd: return "usd"
        case .cad: return "cad"
        case .eur: return "eur"
        case .tix: return "tix"
        }
    }

    /// Whether values in this currency are approximate. Only tix (no real FX rate / separate market).
    var isEstimated: Bool { self == .tix }

    // MARK: Canonical USD (stored)

    /// The canonical USD value of one copy of a card for a finish — the number StatsUpdater stores.
    /// Reads the USD market first (finish fallback within the market), and if the card has no USD
    /// price at all, FX-converts its native price from another market *into USD* so the stored value
    /// is genuinely USD (never a raw EUR figure mislabeled). Returns 0 when nothing is priced.
    static func canonicalUSD(_ p: Prices, finish: CardFinish) -> Double {
        if let usd = marketFinishPrice(p, market: "usd", finish: finish) { return usd }
        if let eur = marketFinishPrice(p, market: "eur", finish: finish) {
            return CurrencyFX.convert(eur, from: "eur", to: "usd")
        }
        return 0
    }

    /// The native (no cross-finish fallback) USD price for exactly one finish, or nil if that finish
    /// isn't priced. Drives the per-finish pills so each shows real data, not a duplicated fallback.
    static func nativeFinishUSD(_ p: Prices, finish: CardFinish) -> Double? {
        func pos(_ s: String) -> Double? { let d = Double(s) ?? 0; return d > 0 ? d : nil }
        switch finish {
        case .nonfoil:
            if let u = pos(p.usd) { return u }
            if let e = pos(p.eur) { return CurrencyFX.convert(e, from: "eur", to: "usd") }
        case .foil:
            if let u = pos(p.usdFoil) { return u }
            if let e = pos(p.eurFoil) { return CurrencyFX.convert(e, from: "eur", to: "usd") }
        case .etched:
            if let u = pos(p.usdEtched) { return u }   // EUR market has no etched price
        }
        return nil
    }

    // MARK: Display (convert canonical USD → this currency)

    /// The collection total in this display currency — the stored canonical USD, FX-converted.
    func total(_ stats: CollectionStats?) -> Double {
        guard let stats else { return 0 }
        return CurrencyFX.convert(stats.totalPriceUSD, from: "usd", to: code)
    }

    /// Convert a raw USD amount (e.g. a value stored canonically in USD) into this display currency.
    func display(usd: Double) -> Double {
        CurrencyFX.convert(usd, from: "usd", to: code)
    }

    /// A single card's value in this display currency (canonical USD converted).
    func value(_ prices: Prices, finish: CardFinish) -> Double {
        CurrencyFX.convert(Self.canonicalUSD(prices, finish: finish), from: "usd", to: code)
    }

    /// Best USD price for a finish within one Scryfall market, falling back to other finishes in
    /// that market. EUR has no etched finish (etched falls to foil, then base).
    private static func marketFinishPrice(_ p: Prices, market: String, finish: CardFinish) -> Double? {
        func num(_ s: String) -> Double { Double(s) ?? 0 }
        let candidates: [Double]
        if market == "eur" {
            let base = num(p.eur), foil = num(p.eurFoil)
            switch finish {
            case .nonfoil:        candidates = [base, foil]
            case .foil, .etched:  candidates = [foil, base]
            }
        } else {
            let base = num(p.usd), foil = num(p.usdFoil), etched = num(p.usdEtched)
            switch finish {
            case .nonfoil: candidates = [base, foil, etched]
            case .foil:    candidates = [foil, base, etched]
            case .etched:  candidates = [etched, foil, base]
            }
        }
        return candidates.first(where: { $0 > 0 })
    }

    /// Format a numeric value in this currency. Uses the narrow currency symbol so values read as
    /// "$1.23" / "€1.23" rather than the locale-prefixed "CA$1.23" / "US$1.23".
    func format(_ value: Double) -> String {
        switch self {
        case .tix: return "\(value.formatted(.number.precision(.fractionLength(2)))) tix"
        case .cad: return value.formatted(.currency(code: "CAD").presentation(.narrow))
        case .usd: return value.formatted(.currency(code: "USD").presentation(.narrow))
        case .eur: return value.formatted(.currency(code: "EUR").presentation(.narrow))
        }
    }

    /// Format a string price (e.g. a Scryfall "1.23") in this currency.
    func format(_ string: String) -> String {
        format(Double(string) ?? 0)
    }

    /// The bare currency symbol, for the compact formatter (the locale formatters above embed it).
    private var symbol: String {
        switch self {
        case .usd, .cad: return "$"
        case .eur:       return "€"
        case .tix:       return ""   // tix reads as a trailing word, not a symbol
        }
    }

    /// A space-savvy form of `format` for tight widgets (summary tiles, grid pills): large values get
    /// K / M / B suffixes (`$12.3K`, `$4.7M`, `$2.1B`). Anything under 1,000 formats normally so small
    /// collections still read exactly. One decimal, truncated toward zero so a total never reads higher
    /// than it is (a $1,999 collection shows `$1.9K`, not `$2.0K`), and a trailing `.0` is dropped.
    func formatCompact(_ value: Double) -> String {
        let magnitude = abs(value)
        guard magnitude >= 1_000 else { return format(value) }

        let scaled: Double, unit: String
        switch magnitude {
        case ..<1_000_000:     scaled = value / 1_000;         unit = "K"
        case ..<1_000_000_000: scaled = value / 1_000_000;     unit = "M"
        default:               scaled = value / 1_000_000_000; unit = "B"
        }

        let truncated = (scaled * 10).rounded(.towardZero) / 10
        let number = truncated == truncated.rounded()
            ? String(format: "%.0f", truncated)
            : String(format: "%.1f", truncated)

        return self == .tix ? "\(number)\(unit) tix" : "\(symbol)\(number)\(unit)"
    }

    /// Per-finish prices for the card price pills, in this display currency. Each finish is taken
    /// from its native USD price (or another market converted to USD), then converted to the display
    /// currency — one consistent path. Finishes without any price are omitted.
    func cardPrices(_ p: Prices) -> [(finish: String, price: String)] {
        var result: [(String, String)] = []
        for (label, finish) in [("Base", CardFinish.nonfoil), ("Foil", .foil), ("Etched", .etched)] {
            guard let usd = Self.nativeFinishUSD(p, finish: finish) else { continue }
            result.append((label, String(CurrencyFX.convert(usd, from: "usd", to: code))))
        }
        return result
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
