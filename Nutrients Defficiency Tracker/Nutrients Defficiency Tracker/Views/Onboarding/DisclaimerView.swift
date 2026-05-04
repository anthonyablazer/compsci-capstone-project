//
//  DisclaimerView.swift
//  Nutrients Deficiency Tracker
//
//  A safety component that establishes the legal and professional boundaries of the application. This view ensures the user understands that the data provided is educational and not a substitute for professional medical advice.
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - 1. VISUAL WARNING
                // Large, high-contrast icon to immediately signal the
                // importance of the content.
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.orange)
                    .padding(.bottom, 8)
                
                Text("Medical Disclaimer")
                    .font(.system(.title, design: .rounded)).bold()
                
                // MARK: - 2. COMPLIANCE CONTENT
                // Breaks down the legal protections into digestible rows.
                VStack(alignment: .leading, spacing: 16) {
                    DisclaimerRow(
                        title: "Not a Medical Device",
                        text: "This application is for informational and educational purposes only. It is not a medical device and should not be used to diagnose, treat, or prevent any medical condition."
                    )
                    
                    DisclaimerRow(
                        title: "Seek Professional Advice",
                        text: "Always seek the advice of a physician or other qualified health provider with any questions you may have regarding a medical condition or nutritional deficiency."
                    )
                    
                    DisclaimerRow(
                        title: "Academic Project",
                        text: "This app was created by a student developer. The creator is not a licensed medical professional, doctor, or registered dietitian."
                    )
                    
                    DisclaimerRow(
                        title: "Data Standards",
                        text: "Nutritional goals are based on NIH (National Institutes of Health) standards, but individual needs may vary. While customizability has been added, Accuracy is not guaranteed."
                    )
                }
            }
            .padding(24)
        }
    }
}

// MARK: - Subcomponent: DisclaimerRow

// A specialized layout for disclaimer items, prioritizing the bold headline
// to ensure the "What" is clear before the "Why."
struct DisclaimerRow: View {
    let title: String
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Bold title for quick scanning
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            
            // Secondary text for detailed legal/safety context
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineSpacing(2)
        }
    }
}
