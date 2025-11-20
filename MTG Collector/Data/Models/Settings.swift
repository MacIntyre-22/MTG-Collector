//
//  Settings.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//  Purpose:
//         Stores user data for preferences

// MARK: Imports

import Foundation
import SwiftData

// MARK: Types

@Model
class Settings {
    var theme: String = "Orange Theme"
    var onBoarding = true
    
    init() {}
}
