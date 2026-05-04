//
//  NotificationManager.swift
//  Nutrients Defficiency Tracker

//  This file is the central hub for Notification creation and handling. This includes managing all local notification logic such permissions, scheduling, and handling user interactions when a notification is tapped.

//  Created by Anthony Blazer.


import UserNotifications
import UIKit

@MainActor
class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // instance to ensure we only have one manager controlling notifications across the app.
    static let instance = NotificationManager()
    // Has the user allowed, denied, or not yet decided on notification permissions?
    @Published var authStatus: UNAuthorizationStatus = .notDetermined
    
    // Holds data from a tapped notification so the UI (Dashboard) can react to it.
    // Includes the nutrient name, the tracking frequency, and the exact time it was sent (for roper range calculation).
    @Published var pendingReportInfo: (name: String, frequency: String, triggerDate: Date)?
    
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - userNotificationCenter()
    // This function is triggered when a user taps on a notification.
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        let triggerDate = response.notification.date

        // Extract the nutrient data we attached to the notification during scheduling.
        if let name = userInfo["nutrientName"] as? String,
           let freq = userInfo["frequency"] as? String {
            
            // We hop back to the MainActor specifically to update the @Published property
            Task { @MainActor in
                self.pendingReportInfo = (name, freq, triggerDate)
                print("Successfully captured notification on launch: \(name)")
                
                // Notify the system we are done processing the action.
                completionHandler()
            }
        } else {
            completionHandler()
        }
    }
    
    // MARK: - checkPermission()
    // This function determines whether the application has Notification permissions.
    func checkPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            // Modern Swift handles this hop via Task or DispatchQueue
            Task { @MainActor in
                self.authStatus = settings.authorizationStatus
            }
        }
    }
    
    // MARK: - requestPermission()
    // THis function performs the 1 time permission request in the onboarding process.
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            Task { @MainActor in
                self.checkPermission()
            }
        }
    }
    
    // MARK: - sync()
    // THis function is a modern approach to motification queue management. This function re-syncs all notification requests based on the user's current reminders and master toggle - this prevents duplicate notifications by clearing and rebuilding the queue.
    func sync(reminders: [NutrientReminder], masterEnabled: Bool) {
        // Clear all existing scheduled notifications to start fresh.
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        // Stop here if notifications are disabled globally in the app.
        guard masterEnabled else { return }

        // Grouping logic: Collects nutrients that share the same schedule to avoid hitting the iOS limit of 64 scheduled notifications.
        var groups: [String: [String]] = [:]
        let active = reminders.filter { $0.isEnabled }

        for r in active {
            let key: String
            switch r.frequency {
            case "Weekly": key = "Weekly-\(r.dayOfWeek)"
            case "Monthly": key = "Monthly-\(r.dayOfMonth)"
            default: key = "Daily"
            }
            groups[key, default: []].append(r.name)
        }

        // Schedule one notification per group.
        for (key, names) in groups {
            scheduleGroup(key: key, names: names)
        }
    }
    
    // MARK: - scheduleGroup()
    // This function constructs and schedules a single notification for a group of nutrients.
    private func scheduleGroup(key: String, names: [String]) {
        let content = UNMutableNotificationContent()
        content.title = "Small But Essential"
        content.sound = .default
        
        // Default notification delivery time (Midnight)
        var components = DateComponents()
        components.hour = 0
        components.minute = 0
        
        let frequency = key.components(separatedBy: "-")[0]
        
        // Attach data to the notification so we know what was clicked in 'didReceive'.
        content.userInfo = [
            "nutrientName": names.joined(separator: ", "),
            "frequency": frequency
        ]
        
        // Handle grammar for the notification body based on how many nutrients are in the group.
        if names.count == 1 { content.body = "Your \(frequency) \(names[0]) Nutrient Report has arrived!" }
        else if names.count <= 3 { content.body = "Your \(frequency) Nutrient Report for \(names.joined(separator: " and ")) is here!" }
        else { content.body = "Your \(frequency) Nutrient Report for various nutrients has arrived!" }
        
        
        let repeats = true
        var trigger: UNNotificationTrigger?
        
        // Determine the notification delivery intercal (trigger) based on the grouping key.
        if key.contains("Weekly") {
            components.weekday = Int(key.split(separator: "-")[1])
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        } else if key.contains("Monthly") {
            components.day = Int(key.split(separator: "-")[1])
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        } else {
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        }
        
        // Create the notification and hand it off to iOS.
        if let trigger = trigger {
            let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
