//
//  Settings.swift
//  Nutrients Deficiency Tracker
//
//  The Settings view serves as the control center for user personalization.
//  It manages the UserProfile, notification authorization flows, and the synchronization of scheduled nutrient reports.
//
//  Created by Anthony Blazer.
//

import SwiftUI
import SwiftData

struct Settings: View {
    
    // Automatically stays in sync with SwiftData storage
    @Query(sort: \NutrientReminder.name) var reminders: [NutrientReminder]
    @Query private var profiles: [UserProfile]
    @Query(sort: \Micronutrient.name) var nutrients: [Micronutrient]
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var mgr = NotificationManager.instance
    @AppStorage("masterNotificationsEnabled") var masterEnabled = false
    @State private var showingProfileEditor = false
    @State private var showingPermissionAlert = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: Profile Header
                // Provides a quick summary of the user's metrics and access to the ProfileSetupView so they can update their profile.
                if let profile = profiles.first {
                    Section {
                        Button {
                            showingProfileEditor = true
                        } label: {
                            HStack(spacing: 16) {
                                // Dynamic Avatar using the first initial of the name
                                ZStack {
                                    Circle()
                                        .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .frame(width: 60, height: 60)
                                    Text(profile.name.prefix(1).uppercased())
                                        .font(.title.bold())
                                        .foregroundStyle(.white)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(profile.name.isEmpty ? "Complete Profile" : profile.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                    
                                    Text("\(Int(profile.age)) yrs • \(Int(profile.weight))lb • \(Int(profile.height))in")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                // MARK: Notification Master Control
                // Intercepts the toggle action to check for system-level notification permissions before enabling.
                Section {
                    Toggle(isOn: Binding(
                        get: { masterEnabled },
                        set: { newValue in
                            handleToggleChange(requestedValue: newValue)
                        }
                    )) {
                        Label {
                            Text("Global Notifications")
                        } icon: {
                            Image(systemName: "bell.badge.fill")
                                .foregroundStyle(.blue)
                        }
                    }
                    .tint(.blue)
                } header: {
                    Text("Controls")
                } footer: {
                    Text("Enable this to enable scheduled alerts for your nutrient goals.")
                }

                // MARK: 3. INDIVIDUAL REMINDERS
                // Dynamically disables rows if the master switch is off or
                // if system permissions are denied.
                Section("Individual Reminders") {
                    ForEach(reminders) { reminder in
                        ReminderRow(reminder: reminder, syncAction: sync)
                    }
                }
                .disabled(!masterEnabled || mgr.authStatus != .authorized)
                .opacity(masterEnabled && mgr.authStatus == .authorized ? 1.0 : 0.5)
            }
            .navigationTitle("Settings")
            
            // GUIDANCE ALERT: Directs user to iOS System Settings if permissions were denied.
            .alert("Enable Notifications", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("To stay consistent with your nutrient goals, the app needs permission to send you alerts. Without this, we can't provide you Nutrient Reports.")
            }
            
            // PROFILE EDITOR: Reuses the Onboarding's ProfileSetupView in a sheet.
            .sheet(isPresented: $showingProfileEditor, onDismiss: {
                refreshGoals()
            }) {
                if let profile = profiles.first {
                    NavigationStack {
                        ProfileSetupView(profile: profile)
                            .navigationTitle("Edit Profile")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Done") { showingProfileEditor = false }
                                }
                            }
                    }
                }
            }
            .onAppear {
                setupInitialData()
                mgr.checkPermission()
            }
        }
    }

    // Populates the reminder table once if it's currently empty.
    private func setupInitialData() {
        if reminders.isEmpty {
            for nutrient in nutrients {
                modelContext.insert(NutrientReminder(name: nutrient.name))
            }
            try? modelContext.save()
        }
    }

    // Manages the state machine between AppStorage and NotificationCenter.
    private func handleToggleChange(requestedValue: Bool) {
        if requestedValue == true {
            if mgr.authStatus == .authorized {
                masterEnabled = true
                sync()
            } else if mgr.authStatus == .notDetermined {
                mgr.requestPermission()
            } else {
                showingPermissionAlert = true
                masterEnabled = false
            }
        } else {
            masterEnabled = false
            sync()
        }
    }
    
    private func sync() {
        mgr.sync(reminders: reminders, masterEnabled: masterEnabled)
    }
    
    /// Recalculates RDAs for all nutrients when biometric data (age/weight) changes.
    /// It respects 'Manual Goals' set by the user to avoid overwriting medical overrides.
    private func refreshGoals() {
        guard let profile = profiles.first else { return }
        
        for nutrient in nutrients {
            if !nutrient.isManualGoal {
                nutrient.dailyGoal = ScienceProvider.getRDA(for: nutrient.name, profile: profile)
                nutrient.upperLimit = ScienceProvider.getUpperLimit(for: nutrient.name)
            }
        }
        try? modelContext.save()
    }
}

