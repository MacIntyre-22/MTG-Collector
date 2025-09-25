//
//  Set.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
import Foundation
import SwiftData

// MARK: Scryfall Set Info
@Model
class Set {
    var name: String
    var releaseDate: Date
    var type: String
    var cardCount: Int
    var iconURI: URL?
    
    init(code: String, name: String, releaseDate: Date, type: String, cardCount: Int, iconURI: URL? = nil) {
        self.name = name
        self.releaseDate = releaseDate
        self.type = type
        self.cardCount = cardCount
        self.iconURI = iconURI
    }
}
