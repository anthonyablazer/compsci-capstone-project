//
//  ReportRevealView.swift
//  Nutrients Defficiency Tracker
//
//  Created by Anthony Blazer.
//

import SwiftUI


struct ReportRevealView: View {
    // The reports that need to be shown to the user.
    let reports: [NutrientReport]
    var onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // The Detailed Cards & Insights
                    ForEach(reports) { report in
                        VStack(spacing: 0) {
                            // Present a graphical view of how the user has done over the report's timeframe.
                            NutrientResultCard(report: report)
                            // Provide suggestions on how to maintain/increase intake levels.
                            NutrientInsightView(report: report)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Analysis")
            .toolbar {
                Button("Done", action: onDismiss).bold()
            }
        }
    }
}
