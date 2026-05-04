//
//  Dashboard.swift
//  Nutrients Defficiency Tracker

//  This file creates and manages the UI and backend logic for the "Dashboard" tab.
//  This tab allows users to view their selected micronutrients, along with a graph and intake summary
//  for each of the micronutrients

//  Created by Anthony Blazer.
//


import SwiftUI
import HealthKit
import SwiftData

struct Dashboard: View {
    // The context used to insert, delete, or save changes to the SwiftData database.
    @Environment(\.modelContext) private var modelContext
    
    // Fetches all nutrient reports from the database, sorted ascending by date.
    @Query(sort: \NutrientReport.date, order: .reverse) var history: [NutrientReport]
    
    //Fetches all micronutrients and sorts them by name.
    @Query(sort: \Micronutrient.name) var profiles: [Micronutrient]
    
    // Fetches all nutrient reminders and order them by name.
    @Query(sort: \NutrientReminder.name) var reminders: [NutrientReminder]
    
    @Query private var userProfiles: [UserProfile]
    
    // Notification instance
    @ObservedObject var ntfMgr = NotificationManager.instance
    
    // State variables
    @State private var currentIntakes: [String: Double] = [:]
    @State private var isAuthorized = false
    @State private var pendingResults: [NutrientReport] = []
    @State private var showRingsSheet = false
    
    // State for the information popup
    @State private var showingGoalsInfo = false
    
    // Computed properties to split micronutrients being tracked from the nontracked.
    private var starredNutrients: [Micronutrient] { // tracked
        let enabledNames = reminders.filter { $0.isEnabled }.map { $0.name }
        return profiles.filter { enabledNames.contains($0.name) }
    }
    private var otherNutrients: [Micronutrient] { // nontracked
        let enabledNames = reminders.filter { $0.isEnabled }.map { $0.name }
        return profiles.filter { !enabledNames.contains($0.name) }
    }
    
    // Whar nutrient are we currently editing?
    @State private var editingNutrient: Micronutrient?
    
    // Grid Configuration for a "Widget" feel
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    // MARK: - Main Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the modern "grouped" look
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // MARK: 1. Dynamic Header
                        headerSection
                        
                        // Determine if the user has allowed access to Micronutrient tracking.
                        if !isAuthorized {
                            authRequiredView
                        } else {
                            // "Goals Met" and "Status" cards
                            dailySummaryCard
                            
                            // MARK: STarred Micronutrients
                            // When users begin tracking a micronutrient, move its card to the top of the Micronutrient list.
                            if !starredNutrients.isEmpty {
                                nutrientGridSection(title: "Monitored", nutrients: starredNutrients)
                            }
                            
                            // MARK: All Nicronutrients
                            // All micronutrients not being tracked are kept together below the tracked ones.
                            if !otherNutrients.isEmpty {
                                nutrientGridSection(title: "\(starredNutrients.isEmpty ? "All" : "Other") Nutrients", nutrients: otherNutrients)
                            }
                            
                            // MARK: Recent Reports
                            if !history.isEmpty {
                                recentReportsSection
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .alert("About Monitored Goals", isPresented: $showingGoalsInfo) {
                Button("Got it", role: .cancel) { }
            } message: {
                Text("This indicates how many goals you've reached today for your **Monitored** nutrients only. Nutrients listed under 'Other' are not included in this count.")
            }
            .onAppear {
                setupHealthKit()
                
                // MARK: COLD START
                // If the app was opened by a notification, pendingReportInfo will be populated before onAppear finishes.
                if ntfMgr.pendingReportInfo != nil {
                    handleNotificationClick()
                }
                
                // Start observing all nutrients for live updates
                for profile in profiles {
                    let id = HKQuantityTypeIdentifier(rawValue: profile.hkIdentifierValue)
                    HealthKitManager.shared.startObservingQuantityType(id)
                }
            }
            // This listens for HealthKit changes while the app is open
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HKDataChanged"))) { _ in
                refreshData()
            }
            .onChange(of: ntfMgr.pendingReportInfo?.triggerDate) { oldDate, newDate in
                if newDate != nil {
                    print("Initial Change Detected: Handling Notification...")
                    handleNotificationClick()
                }
            }
            .toolbar {
                // Place the "refresh" button inline to the Dashboard title.
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: refreshData) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title3)
                    }
                }
            }
            // MARK: Presentation Modals
            // This controls the ability for the UI to, on notification press, show the Nutrient Report over the Dashboard.
            .fullScreenCover(isPresented: Binding(
                get: { !pendingResults.isEmpty },
                set: { if !$0 { pendingResults = [] } }
            )) {
                ReportRevealView(reports: pendingResults) {
                    for report in pendingResults {
                        modelContext.insert(report)
                    }
                    pendingResults = []
                }
            }
            .sheet(item: $editingNutrient) { nutrient in
                GoalOverrideView(nutrient: nutrient) // The editor view we discussed
            }
        }
    }
}


// MARK: Subviews
extension Dashboard {
    
    // MARK: Stylized Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Insights")
                    .font(.system(.largeTitle, design: .rounded).bold())
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    // MARK: - Goals Cards
    private var dailySummaryCard: some View {
        HStack(spacing: 12) {
            let metCount = starredNutrients.filter { (currentIntakes[$0.name] ?? 0) >= $0.dailyGoal }.count
            SummaryStatView(
                label: "Goals Met",
                value: "\(metCount)/\(starredNutrients.count)",
                icon: "target",
                color: .green
            )
            .onTapGesture {
                showingGoalsInfo = true
            }
            
            SummaryStatView(
                label: "\(Date.now.formatted(.dateTime.month(.twoDigits).day(.twoDigits).year(.extended())))",
                value: "Top 5 View",
                icon: "shield.checkered",
                color: .blue
            )
            .frame(maxWidth: .infinity)
            .onTapGesture {
                showRingsSheet = true
            }
            .sheet(isPresented: $showRingsSheet) {
                NutrientRingsView(
                    starredNutrients: starredNutrients,
                    currentIntakes: currentIntakes
                )
                .presentationDetents([.medium, .large]) // Allows that nice Apple-style partial sheet
                .presentationDragIndicator(.visible)
            }        }
        .padding(.horizontal)
    }
    
    // MARK: - Latest Reports
    private var recentReportsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Latest Alerts")
                .font(.system(.headline, design: .rounded))
                .padding(.horizontal)
            
            ForEach(history.prefix(3)) { report in
                NutrientResultCard(report: report)
                    .padding(.horizontal)
                    .scaleEffect(0.95) // Slight hierarchy change
            }
        }
    }
    
    // MARK: - Authorixation Reuqest View
    private var authRequiredView: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue.gradient)
            Text("HealthKit Access Required")
                .font(.headline)
            Text("We need your permission to analyze nutrition data and calculate your shortfalls.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
            Button("Authorize Access") { setupHealthKit() }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .clipShape(Capsule())
        }
        .padding(.top, 60)
    }
    
    // MARK: - Dyanmic Nutrient Monitored/All Sections
    @ViewBuilder
    private func nutrientGridSection(title: String, nutrients: [Micronutrient]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(title)
                    .font(.system(.title3, design: .rounded).bold())
                
                if title == "Monitored" {
                    Image(systemName: "bell.fill")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(nutrients) { profile in
                    NutrientCardView(
                        profile: profile,
                        current: currentIntakes[profile.name] ?? 0.0,
                        onAdjust: {
                            editingNutrient = profile // Sets the state to show the sheet
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}





// MARK: Core Logic (Preserved)
extension Dashboard {
    
    // MARK: - Healthkit Setup
    // If the users has allowed Healthkit authorization, then proceed to setting up the application (refreshData())
    private func setupHealthKit() {
        HealthKitManager.shared.requestAuthorization { success in
            self.isAuthorized = success
            if success { refreshData() }
        }
    }
    
    // MARK: - Data Refresh
    // For every micronutrient, fetch and handle the current total intake.
    private func refreshData() {
        for profile in profiles {
            let type = HKQuantityTypeIdentifier(rawValue: profile.hkIdentifierValue)
            let unit = (profile.unit == "mcg" ? HKUnit.gramUnit(with: .micro) : HKUnit.gramUnit(with: .milli))
            HealthKitManager.shared.fetchTodaysSum(for: type, unit: unit) { sum in
                DispatchQueue.main.async {
                    self.currentIntakes[profile.name] = sum
                }
            }
        }
    }
    
    // MARK: - Notification Handling
    // This function is critical to the appearance and logical flow of the dashboard when a notification is pressed.
    private func handleNotificationClick() {
        // Retrieve the payload from the Notification.
        guard let info = ntfMgr.pendingReportInfo else { return }
        
        // Determine the micronutrients in the payload.
        let nutrientNames = info.name.components(separatedBy: ", ")
        
        // Retrieve timeframe from the payload.
        let days = info.frequency == "Weekly" ? 7 : (info.frequency == "Monthly" ? 30 : 1)
        
        // Use the triggerDate to set the end of the window
        let endDate = info.triggerDate
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: endDate)!

        self.pendingResults = []
        
        // For every micronutrient in the notification, fetch the total intake of the micronutrient over thetimeframe and create a Nutrient Report database entry for the information.
        for name in nutrientNames {
            let cleanName = name.trimmingCharacters(in: .whitespaces)
            guard let profile = profiles.first(where: { profile in
                cleanName.contains(profile.name) || profile.name.contains(cleanName)
            }) else { continue }
            
            let type = HKQuantityTypeIdentifier(rawValue: profile.hkIdentifierValue)
            let unit = (profile.unit == "mcg" ? HKUnit.gramUnit(with: .micro) : HKUnit.gramUnit(with: .milli))
            let totalTarget = profile.dailyGoal * Double(days)
            
            // Use HealthKitManager's fetchSum with exact start/end dates stored in the notification load to ensure correct Nutrient Report numbers over the timeframe.
            HealthKitManager.shared.fetchSum(for: type, unit: unit, start: startDate, end: endDate) { totalIntake in
                DispatchQueue.main.async {
                    let report = NutrientReport(
                        name: profile.name,
                        isSufficient: totalIntake >= totalTarget,
                        timeframe: info.frequency,
                        date: endDate, // Store the report on the date it was meant for
                        totalIntake: totalIntake, // New Field
                        targetGoal: totalTarget    // New Field
                    )
                    self.pendingResults.append(report)
                }
            }
        }
        ntfMgr.pendingReportInfo = nil
    }
}
