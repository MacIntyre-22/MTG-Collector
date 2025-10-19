//
//  HomeSuggestions.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-09-25.
//
import Foundation

// MARK: Home Suggestions Data
struct HomeSuggestions {
    var newCards: [CardJSON] = []
    var popularCards: [CardJSON] = []
    var fullArt: [CardJSON] = []
    var oldSchool: [CardJSON] = []
    var expensive: [CardJSON] = []
    var budget: [CardJSON] = []
}
