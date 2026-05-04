//
//  NutrientCardView.swift
//  Nutrients Deficiency Tracker
//
//  This file creates the view of the visual "widget" card for individual micronutrients.
//  It provides a high-level overview of a specific nutrient's progress, including
//  a progress ring, today's total intake, and a quick-access edit button.
//  On interaction, it will lead into NutrientDetailView where users can see and learn more.
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct NutrientCardView: View {
    // A micronutrient model structure.
    let profile: Micronutrient
    // The current intake amount fetched from HealthKit.
    let current: Double
    var onAdjust: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Main Navigation to NutrientDetailView
            NavigationLink(destination: NutrientDetailView(profile: profile, current: current)) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        // Symbol Block
                        // Displays the chemical symbol (e.g., "Fe" or "Mg") in a stylized box.
                        Text(profile.symbol)
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(profile.gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                        Spacer()
                        
                        // THE MINI PROGRESS RING
                        ZStack {
                            Circle()
                                .stroke(Color.primary.opacity(0.05), lineWidth: 3)
                            Circle()
                                .trim(from: 0, to: min(current / profile.dailyGoal, 1.0))
                                .stroke(profile.gradient, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                        }
                        .frame(width: 32, height: 32)
                    }
                    
                    // Name & Intake Labels
                    VStack(alignment: .leading, spacing: 2) {
                        Text(profile.name) // micronutrient name
                            .font(.system(.subheadline, design: .rounded).bold())
                        
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("\(Int(current))") // current intake
                                .font(.system(.title3, design: .rounded).bold())
                            Text(profile.unit) // nutrient intake unit
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Linear Progress Bar
                    ProgressView(value: min(current / profile.dailyGoal, 1.0))
                        .tint(profile.gradient)
                    
                    // Footer Information
                    HStack {
                        Text("\(Int((current / profile.dailyGoal) * 100))% of goal")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                        
                        // Displays a lock icon if the user has manually overridden the default RDA goal.
                        if profile.isManualGoal {
                            Spacer()
                            Image(systemName: "lock.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(.orange)
                        }
                    }
                }
                .padding(16)
                .background(RoundedRectangle(cornerRadius: 24).fill(Color(.secondarySystemGroupedBackground)))
            }
            .buttonStyle(.plain)

            // 2. THE EDIT BUTTON
            // Overlaid specifically in the top right to sit inside the progress ring.
            // Allows the user to trigger the goal editor without navigating to NutrientDetailView.
            Button {
                onAdjust()
            } label: {
                ZStack {
                    Image(systemName: "pencil.circle.fill")
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, profile.gradient)
                        .font(.system(size: 18))
                }
                .frame(width: 32, height: 32)
            }
            .padding(.trailing, 16)
            .padding(.top, 16)
        }
    }
}
