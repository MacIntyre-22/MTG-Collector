//
//  SetIconRegistry.swift
//  Cardhold
//
//  Created by Ben MacIntyre on 2026-06-17.
//  Purpose:
//      Lightweight in-memory map from set code ("m21") to Scryfall icon_svg_uri. Populated from
//      SwiftData on launch and updated when new sets are fetched, so any view can look up a URI
//      by code without its own database query.
//

import Foundation

final class SetIconRegistry {
    static let shared = SetIconRegistry()
    private var map: [String: String] = [:]
    private init() {}

    func register(code: String, iconURI: String) {
        guard !iconURI.isEmpty else { return }
        map[code] = iconURI
    }

    func iconURI(for code: String) -> String? {
        map[code]
    }
}
