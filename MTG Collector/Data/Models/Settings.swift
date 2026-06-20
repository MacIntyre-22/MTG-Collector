//
//  Settings.swift
//  Cardhold
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

    /// Accent colour as a hex string (free ColorPicker selection). Defaults to the app-icon blue.
    var theme: String = "#007AFF"
    var onBoarding = true

    /// Display currency: "cad" / "usd" / "eur" / "tix".
    var currency: String = "cad"
    /// Card image quality: "normal" / "large".
    var cardImageQuality: String = "normal"
    /// User preference for iCloud sync (the container reads this via UserDefaults at launch).
    /// Off by default — sync is opt-in, so CloudKit is never engaged unless the user turns it on.
    var iCloudSyncEnabled: Bool = false
    /// Default preview visibility for newly created binders/decks.
    var defaultShowPreviews: Bool = true
    /// Pro entitlement — set true after a verified StoreKit purchase.
    var isPro: Bool = false
    /// Show beginner "tap to learn" cues on functional elements (deck roles, legality/format…).
    /// On by default; experts can switch it off to keep the UI uncluttered.
    var beginnerHints: Bool = true

    init() {}

    /// The selected display currency as a typed value.
    var appCurrency: AppCurrency {
        AppCurrency(rawValue: currency) ?? .cad
    }
}
