//
//  NutrientReminder.swift
//  Nutrients Defficiency Tracker

//  This file contains a SwiftData table-like database for Micronutrient reminders. This allows for notification preference storage, which the application uses to set up notifications, group similar notifcations, and more.

//  Created by Anthony Blazer.
//

import Foundation
import SwiftData

@Model
class NutrientReminder {
    var id: UUID = UUID() // Store a unique value for a reminder.
    var name: String
    var frequency: String = "Daily" // "Daily", "Weekly", "Monthly"
    var isEnabled: Bool = false // Default to disabled
    
    // Day Selection
    var dayOfWeek: Int = 2 // 1=Sun, 2=Mon...
    var dayOfMonth: Int = 1 // 1 to 31
    
    // init(): This is how a new NutrientReminder must be declared.
    init(name: String) {
        self.name = name
    }
}
