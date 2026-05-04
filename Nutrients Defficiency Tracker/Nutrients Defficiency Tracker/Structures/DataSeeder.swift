//
//  DataSeeder.swift
//  Nutrients Defficiency Tracker

//

//  Created by Anthony Blazer on 2/7/26.
//

import Foundation
import SwiftData
import HealthKit

@MainActor
class DataSeeder {
    static func seedNutrients(container: ModelContainer) {
        let context = container.mainContext
        
        // 1. Check if we already have data
        let descriptor = FetchDescriptor<Micronutrient>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0
        
        // 2. Only seed if the database is empty
        guard existingCount == 0 else { return }
        
        let nutrients = [
            Micronutrient(
                name: "Iron",
                symbol: "Fe",
                dailyGoal: 0.00,
                upperLimit: 0.00,
                unit: "mg",
                hexStart: "FF4B2B", hexEnd: "FF416C",
                hkID: HKQuantityTypeIdentifier.dietaryIron.rawValue
            ),
            Micronutrient(
                name: "Magnesium",
                symbol: "Mg",
                dailyGoal: 0.00,
                upperLimit: 0.00,
                unit: "mg",
                hexStart: "8E2DE2", hexEnd: "4A00E0",
                hkID: HKQuantityTypeIdentifier.dietaryMagnesium.rawValue
            ),
            Micronutrient(
                name: "Vitamin A",
                symbol: "VA",
                dailyGoal: 0.00,
                upperLimit: 0.00,
                unit: "mcg",
                hexStart: "F2994A", hexEnd: "F2C94C",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminA.rawValue
            ),
            Micronutrient(
                name: "Zinc",
                symbol: "Zn",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "BDBBBE", hexEnd: "9D9EA3",
                hkID: HKQuantityTypeIdentifier.dietaryZinc.rawValue
            ),
            Micronutrient(
                name: "Vitamin D",
                symbol: "VD",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "FDC830", hexEnd: "F37335",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminD.rawValue
            ),
            Micronutrient(
                name: "Vitamin B12",
                symbol: "VB12",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "00B4DB", hexEnd: "0083B0",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminB12.rawValue
            ),
            Micronutrient(
                name: "Vitamin C",
                symbol: "VC",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "FF9966",hexEnd: "FF5E62",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminC.rawValue
            ),
            Micronutrient(
                name: "Vitamin E",
                symbol: "VE",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "D3959B", hexEnd: "B20A2C",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminE.rawValue
            ),
            Micronutrient(
                name: "Vitamin B6",
                symbol: "B6",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "2193B0", hexEnd: "6DD5ED",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminB6.rawValue
            ),
            Micronutrient(
                name: "Thiamin",
                symbol: "B1",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "7F00FF", hexEnd: "E100FF",
                hkID: HKQuantityTypeIdentifier.dietaryThiamin.rawValue
            ),
            Micronutrient(
                name: "Riboflavin",
                symbol: "B2",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "F7971E",hexEnd: "FFD200",
                hkID: HKQuantityTypeIdentifier.dietaryRiboflavin.rawValue
            ),
            Micronutrient(
                name: "Iodine",
                symbol: "I",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "4B0082", hexEnd: "0000FF",
                hkID: HKQuantityTypeIdentifier.dietaryIodine.rawValue
            ),
            Micronutrient(
                name: "Folate",
                symbol: "B9",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg", hexStart: "56AB2F", hexEnd: "A8E063",
                hkID: HKQuantityTypeIdentifier.dietaryFolate.rawValue
            ),
            Micronutrient(
                name: "Calcium",
                symbol: "Ca",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "E0EAFC", hexEnd: "CFDEF3",
                hkID: HKQuantityTypeIdentifier.dietaryCalcium.rawValue
            ),
            Micronutrient(
                name: "Selenium",
                symbol: "Se",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "3E5151", hexEnd: "DECBA4",
                hkID: HKQuantityTypeIdentifier.dietarySelenium.rawValue
            ),
            Micronutrient(
                name: "Niacin",
                symbol: "B3",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "11998E", hexEnd: "38EF7D",
                hkID: HKQuantityTypeIdentifier.dietaryNiacin.rawValue
            ),
            Micronutrient(
                name: "Copper",
                symbol: "Cu",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "B79891", hexEnd: "94716B",
                hkID: HKQuantityTypeIdentifier.dietaryCopper.rawValue
            ),
            Micronutrient(
                name: "Potassium",
                symbol: "K",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mg",
                hexStart: "6441A5", hexEnd: "2A0845",
                hkID: HKQuantityTypeIdentifier.dietaryPotassium.rawValue
            ),
            Micronutrient(
                name: "Vitamin K",
                symbol: "VK",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "#43A047", hexEnd: "#1B5E20",
                hkID: HKQuantityTypeIdentifier.dietaryVitaminK.rawValue
            ),
            Micronutrient(
                name: "Pantothenic Acid",
                symbol: "B5",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "#BA68C8", hexEnd: "#7B1FA2",
                hkID: HKQuantityTypeIdentifier.dietaryPantothenicAcid.rawValue
            ),
            Micronutrient(
                name: "Manganese",
                symbol: "Mn",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "#A1887F", hexEnd: "#5D4037",
                hkID: HKQuantityTypeIdentifier.dietaryManganese.rawValue
            ),
            Micronutrient(
                name: "Phosphorus",
                symbol: "P",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "#7986CB", hexEnd: "#303F9F",
                hkID: HKQuantityTypeIdentifier.dietaryPhosphorus.rawValue
            ),
            Micronutrient(
                name: "Biotin",
                symbol: "B7",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "#F06292", hexEnd: "#C2185B",
                hkID: HKQuantityTypeIdentifier.dietaryBiotin.rawValue
            ),
            Micronutrient(
                name: "Chromium",
                symbol: "Cr",
                dailyGoal: 0.0,
                upperLimit: 0.0,
                unit: "mcg",
                hexStart: "#90A4AE", hexEnd: "#455A64",
                hkID: HKQuantityTypeIdentifier.dietaryChromium.rawValue
            ),
        ]
        
        for nutrient in nutrients {
            context.insert(nutrient)
        }
        
        try? context.save()
        print("✅ Database successfully seeded with nutrients.")
    }
}
