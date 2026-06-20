//
//  BrandFont.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-19.
//  Purpose:
//      The Erben Gothic display face used for the "Cardhold" wordmark (home header, launch splash,
//      onboarding welcome, Pro sheet). Registered at launch with CoreText so no UIAppFonts Info.plist
//      entry is needed, and resolved by its PostScript name.
//

// MARK: Imports

import SwiftUI
import CoreText

// MARK: Brand Font

enum BrandFont {

    /// PostScript name of the bundled Erben Gothic face (erben_gothic.ttf).
    static let postScriptName = "ErbenGothic-Regular"

    /// Register the bundled font with CoreText so `Font.custom` can resolve it. Safe to call once
    /// at launch; CoreText ignores a re-register of the same URL.
    static func register() {
        guard let url = Bundle.main.url(forResource: "erben_gothic", withExtension: "ttf") else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }

    /// The "Cardhold" wordmark at `size`, scaling with Dynamic Type relative to `textStyle`.
    static func wordmark(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .largeTitle) -> Font {
        .custom(postScriptName, size: size, relativeTo: textStyle)
    }
}
