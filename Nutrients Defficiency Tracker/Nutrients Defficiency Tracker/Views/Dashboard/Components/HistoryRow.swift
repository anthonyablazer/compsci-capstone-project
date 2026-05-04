//
//  HistoryRow.swift
//  Nutrients Defficiency Tracker
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct HistoryRow: View {
    let log: NutrientReport
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(log.date.formatted(date: .long, time: .omitted))
                    .font(.system(.subheadline, design: .rounded).bold())
                
                Text(log.isSufficient ? "Target achieved" : "Below daily goal")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 4) {
                Circle()
                    .fill(log.isSufficient ? Color.green : Color.orange)
                    .frame(width: 6, height: 6)
                Text(log.isSufficient ? "MET" : "SHORT")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(log.isSufficient ? .green : .orange)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(log.isSufficient ? .green.opacity(0.1) : .orange.opacity(0.1))
            .clipShape(Capsule())
        }
        .padding()
    }
}
