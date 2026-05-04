//
//  Micronutrient.swift
//  Nutrients Defficiency Tracker

//  This creates a SwiftData table-like database for storing Micronutrients' information. Here is where semi-hardcoded UI values will be stored, along with dynamically determined values such as dailyGoal, upperLimit, and isManualGoal.

//  Created by Anthony Blazer.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Micronutrient {
    @Attribute(.unique) var name: String // "Iron", "Magnesium", etc.
    var symbol: String // For minerals, this will be its periodic table symbol (ex. "Na") and for vitamins, "v<letter>" (ex. vA for vitamin A)
    var dailyGoal: Double // either RDA or what the user sets (in the application).
    var isManualGoal: Bool = false
    var upperLimit: Double // The Tolerable Upper Intake Level (UL)
    var unit: String // ex. mg
    
    // Theme Colors (Stored as Hex strings since SwiftUI Colors can't be saved directly)
    var hexColorStart: String
    var hexColorEnd: String
    
    // HealthKit Linking
    var hkIdentifierValue: String // Store the raw identifier string
    
    // UI Helper for the "Toxicity Zone" end-cap
    var maxLimit: Double {
        upperLimit * 1.4
    }
    
    // init(): This is how a new Micronutrient must be declared.
    init(name: String, symbol: String, dailyGoal: Double, upperLimit: Double, unit: String,
         hexStart: String, hexEnd: String, hkID: String) {
        self.name = name
        self.symbol = symbol
        self.dailyGoal = dailyGoal
        self.upperLimit = upperLimit
        self.unit = unit
        self.hexColorStart = hexStart
        self.hexColorEnd = hexEnd
        self.hkIdentifierValue = hkID
    }
    
    // Computed property to turn hex strings back into a Gradient for the UI
    var gradient: LinearGradient {
        LinearGradient(
            colors: [Color(hexColorStart), Color(hexColorEnd)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// I override SwiftUI's Color component so I can create custom gradients based on hex valeus - allows more color options
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
