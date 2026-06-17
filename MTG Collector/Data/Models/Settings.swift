//
//  Settings.swift
//  Card Hoard
//
//  Created by Ben MacIntyre on 2025-10-19.
//  Purpose:
//         Stores user preferences. New fields finalise SchemaV1 before shipping (currency,
//         image quality, iCloud sync toggle, collection defaults, Pro entitlement).
//

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
class Settings {

    /// Accent colour as a hex string (free ColorPicker selection).
    var theme: String = "#FF9500"
    var onBoarding = true

    /// Display currency: "cad" / "usd" / "eur" / "tix".
    var currency: String = "cad"
    /// Card image quality: "normal" / "large".
    var cardImageQuality: String = "normal"
    /// User preference for iCloud sync (the container reads this via UserDefaults at launch).
    var iCloudSyncEnabled: Bool = true
    /// Default preview visibility for newly created binders/decks.
    var defaultShowPreviews: Bool = true
    /// Pro entitlement — set true after a verified StoreKit purchase.
    var isPro: Bool = false

    init() {}

    /// The selected display currency as a typed value.
    var appCurrency: AppCurrency {
        AppCurrency(rawValue: currency) ?? .cad
    }
}
