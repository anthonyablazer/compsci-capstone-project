//
//  UserProfile.swift
//  Nutrients Defficiency Tracker

//  This file creates a SwiftData table-like database for information related to the user. Though a small file, this information is crucial in calculating Recommended Dietary Allowance, Upper Limit zone, and more that the user builds their nutrition understanding on.

//  Created by Anthony Blazer.
//

import Foundation
import SwiftData
import Observation

@Model
final class UserProfile {
    var name: String = ""
    var age: Double = 25.0
    var gender: String = "Male"
    var weight: Double = 150.0 // lbs
    var height: Double = 68.0  // inches
    var pregnant: Bool = false // pregnant (this will be used in future version for precise calculations).
    
    // init(): This is how a new NutrientReminder must be declared.
    init(name: String = "", age: Double = 25.0, gender: String = "Male", weight: Double = 150.0, height: Double = 68.0, pregnant: Bool = false) {
        self.name = name
        self.age = age
        self.gender = gender
        self.weight = weight
        self.height = height
        self.pregnant = pregnant
    }
}
