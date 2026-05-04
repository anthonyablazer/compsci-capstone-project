//
//  IntroductionView.swift
//  Nutrients Deficiency Tracker
//
//  The welcome screen that gives users insight into the app's mission/scope.
//  It educates the user on the importance of micronutrients and
//  outlines the core features (RDA tracking and HealthKit integration).
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct IntroductionView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // MARK: - 1. HERO HEADER
                // Uses a rounded ZStack with a gradient to create a modern,
                // inviting "Feature Image" equivalent without needing external assets.
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(LinearGradient(
                            colors: [.blue.opacity(0.8), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(height: 220)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                        
                        Text("A glimpse into Small But Essential")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .foregroundStyle(.white)
                    }
                    .padding(24)
                }
                .padding(.top)

                // MARK: - 2. EDUCATIONAL COPY
                // Highlights the "Invisible" nature of micronutrient health
                // to drive home the necessity of the tracker.
                VStack(alignment: .leading, spacing: 16) {
                    Text("Understand your Micronutrients")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("Micronutrients are the silent drivers of your energy, immunity, and brain function. However, they can often be subject to deficiencies when adequate intake is not maintained, which can lead to numerous health drawbacks. Because deficiencies often go unnoticed until they impact your quality of life, understanding your health metrics is the first line of defense. Small But Essential helps you visualize and begin to understand them with precision using medical standards and HealthKit integration.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                    
                    // MARK: - 3. FEATURE HIGHLIGHTS
                    // Uses the reusable FeatureRow component to list core capabilities.
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureRow(
                            icon: "bolt.shield.fill",
                            color: .orange,
                            title: "RDA Tracking",
                            subtitle: "Personalized targets based on you."
                        )
                        FeatureRow(
                            icon: "chart.bar.fill",
                            color: .blue,
                            title: "HealthKit Sync",
                            subtitle: "Automatic updates from your favorite food trackers."
                        )
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(24)
        }
    }
}

// MARK: - Subcomponent: FeatureRow

struct FeatureRow: View {
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container: Consistent sizing ensures text remains aligned across rows.
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
                .frame(width: 32)
            
            VStack(alignment: .leading) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
        }
    }
}
