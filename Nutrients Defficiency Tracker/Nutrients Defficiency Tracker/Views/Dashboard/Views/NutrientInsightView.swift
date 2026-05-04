//
//  NutrientInsightView.swift
//  Nutrients Defficiency Tracker
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct NutrientInsightView: View {
    let report: NutrientReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundStyle(.yellow)
                Text("Health Insight")
                    .font(.subheadline.bold())
            }
            
            Text(generateInsightText())
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Suggested Next Steps")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
                
                ForEach(generateNextSteps(), id: \.self) { step in
                    Label(step, systemImage: "arrow.right.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue.opacity(0.05)))
    }
    
    private func generateInsightText() -> String {
        let percent = report.percentOfGoal
        if percent >= 100 {
            return "Excellent! Your average of \(Int(report.dailyAverage))mg meets your daily requirement. You've maintained a steady intake throughout this \(report.timeframe.lowercased()) period."
        } else if percent >= 70 {
            return "You're close! You reached \(Int(percent))% of your goal. A small adjustment to your snacks or one nutrient-dense meal could bridge the gap."
        } else {
            return "Your \(report.name) intake is significantly below your target, averaging only \(Int(report.dailyAverage))mg per day."
        }
    }
    
    private func generateNextSteps() -> [String] {
        if report.isSufficient {
            return ["Maintain this consistency next week", "Check if you are hitting your Upper Limit (UL)"]
        } else {
            return [
                "Prioritize \(report.name)-rich foods today (See the nutrient's profile for suggestions).",
                "Review your logs for any missed entries",
                "Consider a reminder for your heaviest mealtime"
            ]
        }
    }
}

