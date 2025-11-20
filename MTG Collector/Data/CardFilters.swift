//
//  CardFilters.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         Stores query params to build querys for api search

// MARK: Imports

import Foundation

// MARK: Types

struct CardFilters {
    
    // MARK: Stored Properties
    
    ///
    var text: String = ""
    var colors: [String] = []
    var types: [String] = []
    var sets: [String] = []
    var rarities: [String] = []
    var cmcLower: Double = 0
    var cmcUpper: Double = 20
}

// MARK: Query builder
/// Used to build the proper query based on the populated stored properties
/// for types sets and rarities; join them using OR so users can select multiple
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
    
    if filters.cmcLower < filters.cmcUpper {
        /// if slidders are properly set then append them to search
        parts.append("cmc>=\(filters.cmcLower)")
        parts.append("cmc<=\(filters.cmcUpper)")
    } else {
        /// if not, set upper to max
        /// Prevents errors when upper slider is less than lower slider
        parts.append("cmc>=\(filters.cmcLower)")
        parts.append("cmc<=\(20)")
    }
    
    return parts.joined(separator: " ")
}

