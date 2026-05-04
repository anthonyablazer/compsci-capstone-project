//
//  ReminderRow.swift
//  Nutrients Deficiency Tracker
//
//  A specialized row component for the Settings list. It manages the
//  scheduling preferences for a specific micronutrient, allowing for
//  granular control over notification frequency and timing.
//
//  Created by Anthony Blazer on 3/18/26.
//

import SwiftUI
import SwiftData

struct ReminderRow: View {
    @Bindable var reminder: NutrientReminder
    var syncAction: () -> Void
    
    // Tracks the expansion state of the DisclosureGroup to show/hide
    // frequency settings dynamically.
    @State private var isExpanded: Bool = false
    
    let frequencies = ["Daily", "Weekly", "Monthly"]
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        Group {
            if reminder.isEnabled {
                // MARK: Expanding toggles
                // Uses DisclosureGroup to hide complex scheduling options
                // until the nutrient is actually enabled.
                DisclosureGroup(isExpanded: $isExpanded) {
                    expandedSettings
                } label: {
                    toggleHeader
                }
            } else {
                // MARK: Collapsed State
                // Cleaner UI for disabled items; removes the chevron
                // to signal that settings are currently inaccessible.
                toggleHeader
            }
        }
        .onChange(of: reminder.isEnabled) { _, newValue in
            // Visual UX: Smoothly animate the appearance of settings the moment the toggle is flipped.
            if newValue {
                withAnimation(.snappy) {
                    isExpanded = true
                }
            } else {
                isExpanded = false
            }
            syncAction()
        }
    }

    // MARK: - Subcomponents
    
    private var toggleHeader: some View {
        Toggle(reminder.name, isOn: $reminder.isEnabled)
            .font(.headline)
            .padding(.vertical, 4)
    }

    private var expandedSettings: some View {
        VStack(spacing: 16) {
            // Segmented Picker for high-level frequency selection
            Picker("Frequency", selection: $reminder.frequency) {
                ForEach(frequencies, id: \.self) { Text($0) }
            }
            .pickerStyle(.segmented)
            .padding(.top, 8)
            .onChange(of: reminder.frequency) { _, _ in syncAction() }

            // Informational timing note
            HStack {
                Label(timingNote, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            // Conditional pickers based on the selected frequency
            if reminder.frequency == "Weekly" {
                Picker("Delivery Day", selection: $reminder.dayOfWeek) {
                    ForEach(1...7, id: \.self) { i in
                        Text(daysOfWeek[i-1]).tag(i)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: reminder.dayOfWeek) { _, _ in syncAction() }
            
            } else if reminder.frequency == "Monthly" {
                // Uses a custom calendar grid for selecting the day of the month
                CalendarPicker(selectedDay: $reminder.dayOfMonth, syncAction: syncAction)
            }
        }
    }

    // Translates the timeframe state into a human-readable sentence.
    private var timingNote: String {
        switch reminder.frequency {
        case "Daily":
            return "Alerts arrive at 12:00 AM every day."
        case "Weekly":
            let dayName = daysOfWeek[max(0, min(6, reminder.dayOfWeek - 1))]
            return "Alerts arrive every \(dayName) at 12:00 AM."
        case "Monthly":
            return "Alerts arrive on the \(ordinal(reminder.dayOfMonth)) at 12:00 AM."
        default:
            return "Alerts arrive at 12:00 AM."
        }
    }

    // MARK: ordinal()
    // Converts an integer into a grammatical ordinal (e.g., 1 -> 1st, 2 -> 2nd).
    private func ordinal(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}
