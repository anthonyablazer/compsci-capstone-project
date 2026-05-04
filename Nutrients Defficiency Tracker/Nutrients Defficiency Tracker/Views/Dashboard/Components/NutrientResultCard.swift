//
//  NutrientResultCard.swift
//  Nutrients Deficiency Tracker
//
//  This component creates a summary card for a specific micronutrient report.
//  Communicate whether a user's intake is sufficient or needs attention.
//
//  Created by Anthony Blazer on 2/28/26.
//

import SwiftUI
import Charts

struct NutrientResultCard: View {
    let report: NutrientReport
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // MARK:  Header
            // Dynamic labeling based on sufficiency.
            // Checkmark for 'Met' goals, Triangle warning for 'Shortfalls'.
            HStack {
                Label(report.name, systemImage: report.isSufficient ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(report.isSufficient ? .green : .orange)
                
                Spacer()
                
                // Status Tag: High-visibility capsule indicating intake status
                Text(report.isSufficient ? "MET" : "SHORT")
                    .font(.caption2.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(report.isSufficient ? .green.opacity(0.1) : .orange.opacity(0.1))
                    .foregroundStyle(report.isSufficient ? .green : .orange)
                    .clipShape(Capsule())
            }

            // MARK:  Intake Statistic
            // Compares user's intake numbers against the target goal over the specific timeframe.
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Time Range Intake")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(report.totalIntake))mg")
                        .font(.title3.bold())
                }
                
                VStack(alignment: .leading) {
                    Text("Time Range Goal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(Int(report.targetGoal))mg")
                        .font(.title3.bold())
                }
                
                Spacer()
                
                // Calculation of percentage completion for the current goal.
                let percent = (report.totalIntake / report.targetGoal) * 100
                Text("\(Int(percent))%")
                    .font(.system(.title2, design: .rounded).bold())
                    .foregroundStyle(report.isSufficient ? .green : .orange)
            }

            // MARK: - Progress Visualization
            // Leverages Swift Charts to create a lightweight, unstacked bar chart.
            Chart {
                // The primary bar representing current intake volume.
                BarMark(
                    x: .value("Amount", report.totalIntake),
                    stacking: .unstacked
                )
                .foregroundStyle(report.isSufficient ? Color.green : Color.orange)
                .cornerRadius(4)
                
                // Reference line indicating the "Goal"
                RuleMark(x: .value("Goal", report.targetGoal))
                    .lineStyle(StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundStyle(.secondary)
                    .annotation(position: .top, alignment: .trailing) {
                        Text("Goal")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
            }
            .frame(height: 40)
            .chartXAxis(.hidden) // Clean interface: removes labels inside the card context.
            
            // MARK: Footer
            // Metadata identifying the timeframe and report date.
            Text("\(report.timeframe) Report • \(report.date.formatted(date: .abbreviated, time: .omitted))")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemGroupedBackground)))
    }
}
