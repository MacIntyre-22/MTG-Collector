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
    var id: String?
    var name: String?
    var releaseDate: String?
    var type: String?
    var cardCount: Int?
    var iconURI: String?
    
    init(id: String? = nil, name: String? = nil, releaseDate: String? = nil, type: String? = nil, cardCount: Int? = nil, iconURI: String? = nil) {
        self.name = name
        self.releaseDate = releaseDate
        self.type = type
        self.cardCount = cardCount
        self.iconURI = iconURI
    }
}
