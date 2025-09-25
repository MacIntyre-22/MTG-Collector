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
    var types: [String] = []
    var sets: [String] = []
    var rarities: [String] = []
    var cmcRange: ClosedRange<Int>? = nil
}

// MARK: Query builder
// cannect all the queries
// for types sets and rarities, join using or so users can select multiple
func buildQuery(from filters: CardFilters) -> String {
    var parts: [String] = []
    
    if !filters.text.isEmpty {
        parts.append(filters.text)
    }
    
    if !filters.types.isEmpty {
        let joined = filters.types.map { "type:\($0)" }.joined(separator: " OR ")
        parts.append("(\(joined))")
    }
    
    if !filters.colors.isEmpty {
        let joined = filters.colors.joined()
        parts.append("c:\(joined)")
    }
    
    if !filters.sets.isEmpty {
        let joined = filters.sets.map { "set:\($0)" }.joined(separator: " OR ")
        parts.append("(\(joined))")
    }
    
    if !filters.rarities.isEmpty {
        let joined = filters.rarities.map { "rarity:\($0)" }.joined(separator: " OR ")
        parts.append("(\(joined))")
    }
    
    // set lowest and highest based on user input
    if let cmcRange = filters.cmcRange {
        parts.append("cmc>=\(cmcRange.lowerBound)")
        parts.append("cmc<=\(cmcRange.upperBound)")
    }
    
    // return the query
    return parts.joined(separator: " ")
}

