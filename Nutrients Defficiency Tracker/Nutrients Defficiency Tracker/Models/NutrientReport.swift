//
//  NutrientReport.swift
//  Nutrients Defficiency Tracker

//  This file creates a SwiftData table-like database for storing micronutrient reports. This structure stores the suffiency level, the timframe this is addressing, and more.
//  When a notification is received and pushed, the timeframe analytics are stored here.

//  Created by Anthony Blazer.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class NutrientReport {
    var name: String // Micronutrient name
    var isSufficient: Bool // On this report, was the user sufficient on this micronutrient?
    var date: Date // date added to the database
    var timeframe: String // "Daily", "Weekly", or "Monthly"
    var totalIntake: Double // The actual sum
    var targetGoal: Double   // What a user was supposed to hit
    
    // init(): This is how a new NutrientReminder must be declared.
    init(name: String, isSufficient: Bool, timeframe: String, date: Date = .now, totalIntake: Double, targetGoal: Double) {
        self.name = name
        self.isSufficient = isSufficient
        self.timeframe = timeframe
        self.date = date
        self.totalIntake = totalIntake
        self.targetGoal = targetGoal
    }
}


// The variables entended to the NutrientReport are variables that do not need to be declared in initiation. Additionally, several are used for statistics in the Report screen.
extension NutrientReport {
    // Pick a color based on the frequency
    var timeframeColor: Color {
        switch timeframe {
        case "Daily": return .blue
        case "Weekly": return .purple
        case "Monthly": return .orange
        default: return .gray
        }
    }
    
    // Determine the amount of days to divide the sum of intake by (the denominator of the mean calculation)
    var daysInPeriod: Double {
        switch timeframe {
        case "Weekly": return 7
        case "Monthly": return 30
        case "Minutely": return 1 // For testing
        default: return 1 // Daily
        }
    }
    
    // Mean calculation
    var dailyAverage: Double {
        totalIntake / daysInPeriod
    }
    
    // Convert mean to a percentage
    var percentOfGoal: Double {
        (totalIntake / targetGoal) * 100
    }
}

