//
//  NutrientRingsView.swift
//  Nutrients Defficiency Tracker

//  A high-level dashboard visualizing the top 5 "starred" micronutrients.
//  This view uses concentric rings to represent relative progress toward
//  daily goals, coupled with a detailed breakdown for safety limit monitoring.

//  Created by Anthony Blazer.
//
import SwiftData
import SwiftUI

struct NutrientRingsView: View {
    @Environment(\.dismiss) var dismiss
    let starredNutrients: [Micronutrient]
    let currentIntakes: [String: Double]
    
    // State variable to trigger the ring-drawing animation on appearance.
    @State private var animateRings = false
    
    // Logic to limit the display to the top 5 tracked items,
    // ensuring the concentric UI remains legible and performant.
    var displayMicros: [Micronutrient] {
        Array(starredNutrients.prefix(5))
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                // MARK:  INFO HEADER
                // Explains the dashboard logic to the user; helpful for onboarding.
                VStack(alignment: .leading, spacing: 8) {
                    Text("About Top 5 View")
                        .font(.headline)
                    Text("This dashboard highlights your top 5 starred nutrients. Each ring represents your progress toward your daily goal, allowing you to track your most important micronutrients at a glance.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding()

                if displayMicros.isEmpty {
                    // MARK: EMPTY STATE
                    // Provides clear guidance on how to see nutrient rings the dashboard via Settings.
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "star.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No Nutrients Monitored")
                            .font(.title3)
                            .bold()
                        
                        Text("Head over to your Settings and activate Individual Reminders for some nutrients to see your daily activity rings here.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 40)
                    }
                    Spacer()
                } else {
                    // MARK: ACTIVE DASHBOARD
                    ScrollView {
                        VStack(spacing: 20) {
                            // Concentric Ring Stack
                            ZStack {
                                ForEach(0..<displayMicros.count, id: \.self) { index in
                                    let micro = displayMicros[index]
                                    let intake = currentIntakes[micro.name] ?? 0.0
                                    
                                    NutrientRing(
                                        nutrient: micro,
                                        progress: intake / micro.dailyGoal,
                                        index: index,
                                        isAnimating: $animateRings
                                    )
                                }
                                
                                // Center Label: Displays aggregate progress percentage.
                                VStack {
                                    Text("Today")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    Text("\(Int((totalProgress() * 100)))%")
                                        .font(.system(.title, design: .rounded))
                                        .bold()
                                }
                            }
                            .padding(.vertical, 30)

                            // MARK: NUTRIENT BREAKDOWN LIST
                            // Linear representation of ring data with specific mg/mcg values.
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Nutrient Breakdown")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ForEach(displayMicros) { micro in
                                    let intake = currentIntakes[micro.name] ?? 0.0
                                    let progress = intake / micro.dailyGoal
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Circle()
                                                .fill(Color(hex: micro.hexColorStart))
                                                .frame(width: 8, height: 8)
                                            Text(micro.name).font(.subheadline).bold()
                                            Spacer()
                                            Text("\(Int(intake))/\(Int(micro.dailyGoal)) \(micro.unit)")
                                                .font(.caption).foregroundColor(.secondary)
                                        }
                                        
                                        // Standard progress bar for precise linear comparison.
                                        ProgressView(value: min(progress, 1.0))
                                            .tint(Color(hex: micro.hexColorStart))
                                        
                                        // SAFETY CHECK: Displays a warning if the toxicity upper limit is reached.
                                        if intake >= micro.upperLimit && micro.upperLimit != 0 {
                                            Label("Exceeding Upper Limit", systemImage: "exclamationmark.triangle.fill")
                                                .font(.caption2).foregroundColor(.red)
                                        }
                                    }
                                    .padding(.horizontal)
                                    Divider().padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Daily Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                // Slight delay ensures the view is fully rendered before triggering
                // the ring growth animation.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateRings = true
                }
            }
        }
    }
    
    /// Calculates the average progress across all monitored nutrients.
    func totalProgress() -> Double {
        guard !displayMicros.isEmpty else { return 0 }
        let total = displayMicros.reduce(0.0) { $0 + (currentIntakes[$1.name] ?? 0.0) / $1.dailyGoal }
        return total / Double(displayMicros.count)
    }
}

// MARK: - Subcomponent: Nutrient Ring

struct NutrientRing: View {
    let nutrient: Micronutrient
    let progress: Double
    let index: Int
    @Binding var isAnimating: Bool

    var body: some View {
        ZStack {
            // Background Track: A faint version of the nutrient's color.
            Circle()
                .stroke(Color(hex: nutrient.hexColorStart).opacity(0.15), lineWidth: 18)
            
            // Progress Ring: Animated trim effect.
            Circle()
                .trim(from: 0, to: isAnimating ? CGFloat(min(progress, 1.0)) : 0)
                .stroke(
                    Color(hex: nutrient.hexColorStart),
                    style: StrokeStyle(lineWidth: 18, lineCap: .round)
                )
                .rotationEffect(.degrees(-90)) // Start from the top (12 o'clock)
        }
        // Dynamically scales the ring size based on its index position (0 to 4).
        .frame(width: CGFloat(260 - (index * 42)), height: CGFloat(260 - (index * 42)))
        // Uses a spring animation with an incremental delay for a staggered "reveal" effect.
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: isAnimating)
    }
}
