//
//  SummaryStatView.swift
//  Nutrients Deficiency Tracker
//
//  This file creates a reusable UI component for displaying summary statistics on the Dashboard.
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct SummaryStatView: View {
    // The descriptive name of the statistic (e.g., "Goals Met")
    let label: String
    let value: String
    
    // The SF Symbol name
    let icon: String
    
    // The accent color
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // MARK: - Header Row
            // This top section aligns the label and icon alongside a subtle interaction hint.
            HStack(alignment: .top) {
                // Displays the category name and icon with a polished, secondary look.
                Label(label, systemImage: icon)
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                
                Spacer()
                
                // A subtle icon that hints to the user that this card can be interacted with.
                // It is kept at low opacity.
                Image(systemName: "hand.tap.fill")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .opacity(0.6)
                    .padding(.top, -2)
            }
            
            // MARK: - Value Display
            // The primary data point, styled with a rounded font and the assigned theme color.
            Text(value)
                .font(.system(.title3, design: .rounded).bold())
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemGroupedBackground))
        )
        // Defines the tappable area of the view to match the rounded background shape.
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}
