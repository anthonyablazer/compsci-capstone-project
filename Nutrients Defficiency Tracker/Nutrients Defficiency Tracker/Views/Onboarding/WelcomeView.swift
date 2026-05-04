//
//  WelcomeView.swift
//  Nutrients Deficiency Tracker
//
//  The final step in the onboarding sequence. This view confirms successful setup, provides a brief education on terminology, and provides statements to celebrate the user's completion.
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct WelcomeView: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 30) {
            // MARK: Success!
            // Combines a soft circular backdrop with the iOS 17+ bounce effect
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                    .symbolEffect(.bounce, value: name)
            }
            .padding(.top, 40)
            
            VStack(spacing: 12) {
                Text("You're all set, \(name)!")
                    .font(.system(.title, design: .rounded))
                    .bold()
                
                Text("Your micronutrient journey starts now. Here is how to read your data:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            // MARK: Terminology Onboarding
            // Briefly explains technical concepts (RDA, Deficiencies, Syncing) so the user understands jargon while navigating the main dashboard.
            VStack(spacing: 16) {
                InfoCard(
                    title: "What is RDA?",
                    description: "Recommended Dietary Allowance. It's the daily intake level sufficient to meet the nutrient requirements of 97% of healthy people.",
                    icon: "target",
                    color: .green
                )
                
                InfoCard(
                    title: "Tracking Deficiencies",
                    description: "If your intake is consistently below the RDA, we'll alert you to help prevent long-term health issues.",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange
                )
                
                InfoCard(
                    title: "Automatic Sync",
                    description: "Any food logged in Apple Health will automatically update your charts here in real-time.",
                    icon: "arrow.triangle.2.circlepath",
                    color: .blue
                )
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            // Triggers a 'success' vibration pattern. This physical response
            // reinforces the positive action of completing the profile setup.
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

// MARK: - Subcomponent: InfoCard

// A stylized card for displaying educational snippets with an icon.
struct InfoCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title3)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true) // Allows text wrapping in VStack
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}
