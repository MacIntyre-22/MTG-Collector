//
//  CardFilters.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//

import Foundation


// MARK: Card filters
// sets queries for api
struct CardFilters {
    var text: String = ""
    var colors: [String] = []
    var type: String? = nil
    var set: String? = nil
    var rarity: String? = nil
    var cmcRange: ClosedRange<Int>? = nil
}

// MARK: Query builder
// connects all the filters
func buildQuery(from filters: CardFilters) -> String {
    var parts: [String] = []
    
    if !filters.text.isEmpty {
        parts.append(filters.text)
    }
    if let type = filters.type {
        parts.append("type:\(type)")
    }
    if !filters.colors.isEmpty {
        let joined = filters.colors.joined()
        parts.append("c:\(joined)")
    }
    if let set = filters.set {
        parts.append("set:\(set)")
    }
    if let rarity = filters.rarity {
        parts.append("rarity:\(rarity)")
    }
    if let cmcRange = filters.cmcRange {
        parts.append("cmc>=\(cmcRange.lowerBound)")
        parts.append("cmc<=\(cmcRange.upperBound)")
    }
    
    return parts.joined(separator: " ")
}
