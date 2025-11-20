//
//  Set.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         Stores info about sets, mainly used for filtering

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
class SetInfo {
    
    // MARK: Stored Properties
    
    @Attribute(.unique) var code: String
    var name: String
    var releaseDate: String
    var type: String
    var cardCount: Int
    var iconURI: String
    
    init(code: String, name: String = "", releaseDate: String = "", type: String = "", cardCount: Int = 0, iconURI: String = "") {
        self.code = code
        self.name = name
        self.releaseDate = releaseDate
        self.type = type
        self.cardCount = cardCount
        self.iconURI = iconURI
    }
}
