//
//  NutrientDetailView.swift
//  Nutrients Deficiency Tracker
//
//  This view provides an intensive breakdown of a specific micronutrient.
//  It includes real-time intake tracking, goal management, historical charts,
//  and organized reports for daily, weekly, and monthly progress.
//
//  Created by Anthony Blazer.
//

import SwiftUI
import SwiftData
import Charts
import HealthKit

struct NutrientDetailView: View {
    let profile: Micronutrient
    let current: Double
    @Environment(\.dismiss) var dismiss
    
    // Fetch all historical reports to filter for this specific nutrient
    @Query(sort: \NutrientReport.date, order: .reverse) var allHistory: [NutrientReport]
    
    // Manage graph view and bar points ("bars")
    @State private var chartData: [ChartDataPoint] = []
    @State private var comparisonData: [ChartDataPoint] = []
    @State private var selectedRange: String = "Week"
    @State private var showingGoalEditor = false

    // Filters the global History query for the nutrient currently being viewed
    var nutrientHistory: [NutrientReport] {
        allHistory.filter { $0.name == profile.name }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        // MARK: Hero Summary Card
                        // Shows the current daily intake value and a progress ring.
                        heroStatusSection
                        
                        // MARK: Goal Management
                        // Displays current target and provides access to the GoalOverrideView sheet.
                        VStack(spacing: 12) {
                            Button {
                                showingGoalEditor = true
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Daily Target")
                                            .font(.system(.subheadline, design: .rounded).bold())
                                            .foregroundStyle(.secondary)
                                        
                                        HStack(spacing: 6) {
                                            Text("\(Int(profile.dailyGoal))\(profile.unit)")
                                                .font(.system(.title3, design: .rounded).bold())
                                            
                                            if profile.isManualGoal {
                                                Image(systemName: "lock.fill")
                                                    .font(.caption2)
                                                    .foregroundStyle(.orange)
                                            }
                                        }
                                    }
                                    Spacer()
                                    
                                    Label("Adjust", systemImage: "pencil.line")
                                        .font(.system(.caption, design: .rounded).bold())
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(profile.gradient.opacity(0.1))
                                        .foregroundStyle(profile.gradient)
                                        .clipShape(Capsule())
                                }
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 24).fill(Color(.secondarySystemGroupedBackground)))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal)

                        // MARK: Performance Chart
                        // Toggles that allow visualization of intake trends for a timeframe.
                        VStack(alignment: .center, spacing: 20) {
                            Picker("Range", selection: $selectedRange) {
                                Text("Today").tag("Today")
                                Text("Week").tag("Week")
                                Text("Month").tag("Month")
                            }
                            .pickerStyle(.segmented)
                            .onChange(of: selectedRange) { _, _ in updateChart() }
                            
                            
                            // GRAPH
                            NutrientChartView(
                                currentData: chartData,
                                previousData: comparisonData,
                                goal: profile.dailyGoal,
                                upperLimit: profile.upperLimit,
                                max: profile.maxLimit,
                                gradient: profile.gradient,
                                unit: profile.unit,
                                selectedRange: selectedRange
                            )
        
                            // Scientific data about the nutrient (sources, deficiency signs, etc.)
                            NutrientProfileView(profile: profile)
                        }
                        .padding(.horizontal)
                        
                        // MARK: - 4. History Logs
                        // Collapsible sections for Daily, Weekly, and Monthly reports.
                        VStack(alignment: .leading, spacing: 12) {
                            Text("History & Reports")
                                .font(.system(.headline, design: .rounded))
                                .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                HistorySection(title: "Daily Checks", timeframe: "Daily", color: .blue, logs: nutrientHistory)
                                HistorySection(title: "Weekly Summary", timeframe: "Weekly", color: .purple, logs: nutrientHistory)
                                HistorySection(title: "Monthly Audit", timeframe: "Monthly", color: .orange, logs: nutrientHistory)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(profile.name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { updateChart() }
            .sheet(isPresented: $showingGoalEditor) {
                GoalOverrideView(nutrient: profile)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.tertiary)
                            .font(.title2)
                    }
                }
            }
        }
    }
}

// MARK: - Subviews
extension NutrientDetailView {
    
    // Current intake view and ring
    private var heroStatusSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(Int(current)) \(profile.unit)")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text("Current Intake")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Percentage Circle
            ZStack {
                Circle()
                    .stroke(profile.gradient.opacity(0.1), lineWidth: 6)
                Circle()
                    .trim(from: 0, to: min(current / profile.dailyGoal, 1.0))
                    .stroke(profile.gradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int((current / profile.dailyGoal) * 100))%")
                    .font(.system(.caption, design: .rounded).bold())
            }
            .frame(width: 60, height: 60)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color(.secondarySystemGroupedBackground)))
        .padding(.horizontal)
    }
}

// MARK: - Data Logic
extension NutrientDetailView {
    // Refreshes the chart data by querying HealthKit for the current and previous periods.
    func updateChart() {
        let identifier = HKQuantityTypeIdentifier(rawValue: profile.hkIdentifierValue)
        let hkUnit = (profile.unit == "mcg" ? HKUnit.gramUnit(with: .micro) : HKUnit.gramUnit(with: .milli))
        
        // Fetch data for current time frame
        HealthKitManager.shared.fetchChartData(for: identifier, unit: hkUnit, range: selectedRange, isPrevious: false) { data in
            DispatchQueue.main.async {
                self.chartData = data
            }
        }
        
        // Fetch Previous data for comparison chart ("yeserday", "last week", "the last few weeks")
        HealthKitManager.shared.fetchChartData(for: identifier, unit: hkUnit, range: selectedRange, isPrevious: true) { data in
            DispatchQueue.main.async {
                self.comparisonData = data
            }
        }
    }
}
