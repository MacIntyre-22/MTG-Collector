//
//  AppHTTP.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-18.
//  Purpose:
//      Shared HTTP constants. The `userAgent` identifies the app and gives Scryfall (and the FX
//      provider) a way to reach the developer per Scryfall's API guidelines — it points at the
//      public support page, never a personal inbox. Sent on every outbound request; defined once
//      here so SFAPI and CurrencyRates can never drift apart.
//

// MARK: Imports

import Foundation

// MARK: HTTP

enum AppHTTP {
    /// Sent as the `User-Agent` on all outbound requests. Contact is the public support page.
    static let userAgent = "Cardhold/1.0 (+https://cardhold.ca/support)"
}
