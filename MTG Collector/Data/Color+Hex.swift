//
//  Color+Hex.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-16.
//  Purpose:
//      Hex <-> Color conversion so the accent theme can be a free ColorPicker selection stored
//      as a hex string in Settings.theme.
//

// MARK: Imports

import SwiftUI
import UIKit

// MARK: Color

extension Color {

    /// Create a colour from a "#RRGGBB" (or "RRGGBB") string. Returns nil if it can't parse.
    init?(hex: String) {
        var string = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if string.hasPrefix("#") { string.removeFirst() }
        guard string.count == 6, let value = UInt64(string, radix: 16) else { return nil }
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }

    /// "#RRGGBB" representation of this colour.
    var hex: String {
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        ui.getRed(&r, green: &g, blue: &b, alpha: &a)
        // Wide-gamut (Display P3) picks can return components slightly outside 0...1; clamp before
        // converting so we never produce a >2-digit hex byte (which would make Color(hex:) fail and
        // silently fall back to the default accent).
        func byte(_ v: CGFloat) -> Int { Int((min(max(v, 0), 1) * 255).rounded()) }
        return String(format: "#%02X%02X%02X", byte(r), byte(g), byte(b))
    }
}

// MARK: - App Tint Environment

/// The resolved accent colour for the app, threaded through the environment so it reaches places
/// `Color.accentColor` can't: a raw `Color.accentColor` value always resolves to the asset-catalog
/// AccentColor (orange) and ignores `.tint()`. Reading `\.appTint` instead lets every view follow
/// the user's chosen theme — including content presented in sheets, which don't reliably inherit
/// the built-in tint.
private struct AppTintKey: EnvironmentKey {
    static let defaultValue: Color = .orange
}

extension EnvironmentValues {
    var appTint: Color {
        get { self[AppTintKey.self] }
        set { self[AppTintKey.self] = newValue }
    }
}

// MARK: - Game Status Palette

/// Fixed (non-adaptive) status colours shared by the legality widgets and planeswalker loyalty
/// badges. SwiftUI's semantic `.green`/`.red` lighten in dark mode, which washes them out under
/// white text; these stay dark enough for white text to read in both appearances and keep the
/// legality colours and loyalty costs visually consistent.
extension Color {
    /// Legal / loyalty gain (+).
    static let statusGreen  = Color(red: 0.20, green: 0.52, blue: 0.24)
    /// Not legal / banned / loyalty cost (−).
    static let statusRed    = Color(red: 0.78, green: 0.16, blue: 0.16)
    /// Restricted / caution.
    static let statusOrange = Color(red: 0.85, green: 0.45, blue: 0.10)
}
