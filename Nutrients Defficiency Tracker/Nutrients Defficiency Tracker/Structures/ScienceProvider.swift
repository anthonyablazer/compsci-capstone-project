//
//  ScienceProvider.swift
//  Nutrients Defficiency Tracker

//  This structure stores the necessary functions to calculate health parameters for the user.
//  DISCLAIMER: I am not a doctor or even a degree-seeking undegraduate for medicine/nutrition/health. All calculations and isnights are provided by NIH standards. Disclaimers similar to this can be seen throughout the application.

//  Created by Anthony Blazer.

import Foundation

struct ScienceProvider {
    
    // MARK: getRDA()
    // Returns the RDA (Recommended Dietary Allowance) based on NIH Guidelines
    // Citations: NIH Office of Dietary Supplements (ODS) - Nutrient Recommendations: Dietary Reference Intakes (DRI)
    static func getRDA(for nutrientName: String, profile: UserProfile) -> Double {
        switch nutrientName {
        case "Iron":
            if profile.gender == "Female" {
                if profile.age >= 19 && profile.age <= 50 { return 18.0 } // Menstruating
                if profile.age > 50 { return 8.0 } // Post-menopausal
                return 15.0 // Teens (14-18)
            } else {
                if profile.age >= 19 { return 8.0 }
                return 11.0 // Teens
            }
            
        case "Magnesium":
            if profile.gender == "Male" {
                return profile.age > 30 ? 420.0 : 400.0
            } else {
                return profile.age > 30 ? 320.0 : 310.0
            }
            
        case "Vitamin A":
            return profile.gender == "Male" ? 900.0 : 700.0
        
        case "Vitamin D":
            return profile.age > 70 ? 20.0 : 15.0 // mcg (600-800 IU)
            
        case "Vitamin B12":
            return 2.4 // mcg (Standard for adults)
            
        case "Zinc":
            return profile.gender == "Male" ? 11.0 : 8.0 // mg
            
        case "Vitamin C":
            return profile.gender == "Male" ? 900.0 : 75.0 // mg
            
        case "Vitamin E":
            return 15.0 // mg
            
        case "Vitamin B6":
            if profile.age > 50 {
                return profile.gender == "Male" ? 1.7 : 1.5
            }
            return 1.3
            
        case "Thiamin":
            return profile.gender == "Male" ? 1.2 : 1.1 // mg
            
        case "Riboflavin":
            return profile.gender == "Male" ? 1.3 : 1.1 // mg
            
        case "Iodine":
                    return 150.0 // mcg
            
        case "Folate":
            return 400.0 // mcg DFE
            
        case "Calcium":
            if profile.gender == "Male" {
                return profile.age > 70 ? 1200.0 : 1000.0
            }
            return profile.age > 50 ? 1200.0 : 1000.0
            
        case "Selenium":
            return 55.0 // mcg
            
        case "Niacin":
            return profile.gender == "Male" ? 16.0 : 14.0 // mg NE
            
        case "Copper":
            return 0.9 // mg (900 mcg)
            
        case "Potassium":
            return profile.gender == "Male" ? 3400.0 : 2600.0 // mg (AI)
            
        case "Vitamin K":
            return profile.gender == "Male" ? 120.0 : 90.0 // mcg
            
        case "Pantothenic Acid":
            return 5.0 // mg
            
        case "Manganese":
            return profile.gender == "Male" ? 2.3 : 1.8 // mg
            
        case "Phosphorus":
            return 700.0 // mg
            
        case "Biotin":
            return 30.0 // mcg
            
        case "Chromium":
            return profile.gender == "Male" ? 35.0 : 25.0 // mcg
            
        default:
            return 0.0
        }
    }
    
    
    // MARK: getUpperLimit()
    // Returns the UL (Tolerable Upper Intake Level) - the maximum daily intake unlikely to cause adverse health effects.
    // Citation: National Academies of Sciences, Engineering, and Medicine - Dietary Reference Intakes Reports
    static func getUpperLimit(for nutrientName: String) -> Double {
        switch nutrientName {
        case "Iron":
            return 45.0 // mg (Adults 19+)
        case "Magnesium":
            // Note: The UL for magnesium (350mg) applies ONLY to supplemental magnesium.
            // Magnesium naturally occurring in food is not known to cause health risks.
            return 350.0
        case "Vitamin A":
            return 3000.0 // mcg (Retinol)
        case "Zinc":
            return 40.0 // mg
        case "Vitamin D":
            return 100.0 // mcg (4000 IU)
        case "Vitamin C":
            return 2000.0 // mg
        case "Vitamin E":
            return 1000.0 // mg
        case "Vitamin B6":
            return 100.0 // mg
        case "Iodine": return 1100.0 // mcg
        case "Folate": return 1000.0 // mcg (Synthetic)
        case "Calcium": return 2500.0 // mg (19-50y), 2000mg (51y+)
        case "Selenium": return 400.0 // mcg
        case "Niacin": return 35.0 // mg (Synthetic)
        case "Copper": return 10.0 // mg (10,000 mcg)
        case "Manganese": return 11.0 // mg
        case "Phosphorus": return 4000.0 // mg
        case "Thiamin", "Riboflavin", "Vitamin B12", "Vitamin K", "Pantothenic Acid", "Biotin", "Chromium":
            return 0.0 // No established UL for these
        default:
            return 0.0
        }
    }
}
