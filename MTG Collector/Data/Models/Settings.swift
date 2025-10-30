//
//  Settings.swift
//  MTG Collector
//
//  Created by Ben MacIntyre (School) on 2025-10-19.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class Settings {
    
    // set default settings
    var theme: String = "Orange Theme"
    var onBoarding = true
    
    init() {}
}
