//
//  HomeSuggestions.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//  Purpose:
//         Stores resulta from filtered api calls that are used to dsiplay home screen card suggestions
//  External Types:
//         CardJSON

// MARK: Imports

import Foundation

// MARK: Types

struct HomeSuggestions {
    
    // MARK: Stored Properties
    
    var newCards: [CardJSON] = []
    var popularCards: [CardJSON] = []
    var fullArt: [CardJSON] = []
    var oldSchool: [CardJSON] = []
    var expensive: [CardJSON] = []
    var budget: [CardJSON] = []
}
