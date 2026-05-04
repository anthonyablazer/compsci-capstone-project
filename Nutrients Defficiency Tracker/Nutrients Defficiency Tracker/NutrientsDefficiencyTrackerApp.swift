//
//  Nutrients_Defficiency_TrackerApp.swift
//  Nutrients Defficiency Tracker
//
//  This is the initializer for the entire application. Here, we create a SwiftData schema, creating the SwiftData "tables" (Models) used to persist the data attained and calculated throughout the application. Lastly, we enter the application!

//  Created by Anthony Blazer on 9/10/25.
//

import SwiftUI
import SwiftData
import HealthKit



@main
struct MicronutritionTrackerApp: App {
    // This line is the crucial for Cold Starts - It initializes a NotificationManager() before the UI even loads.
    @StateObject private var ntfMgr = NotificationManager.instance
    let container: ModelContainer // This is where the schema of the SwiftData Models will be stored.
    
    init() {
            do {
                // Define which models should be available throughout the application.
                let schema = Schema([
                    UserProfile.self,
                    NutrientReminder.self,
                    NutrientReport.self,
                    Micronutrient.self
                ])
                let config = ModelConfiguration(schema: schema)
                container = try ModelContainer(for: schema, configurations: config)
            } catch {
                fatalError("Failed to start SwiftData container: \(error)")
            }
        }

    var body: some Scene {
        WindowGroup {
            // ENTER THE APP
            ContentView()
        }
        .modelContainer(container) // surround the application with the SwiftData Models
    }
    
}
