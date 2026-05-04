//
//  HistorySection.swift
//  Nutrients Defficiency Tracker
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct HistorySection: View {
    let title: String
    let timeframe: String // "Daily", "Weekly", "Monthly"
    let color: Color
    let logs: [NutrientReport]
    
    @State private var isExpanded = false
    
    private var filteredLogs: [NutrientReport] {
        logs.filter { $0.timeframe == timeframe }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header Toggle
            Button {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 32, height: 32)
                        Image(systemName: iconName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.system(.subheadline, design: .rounded).bold())
                            .foregroundStyle(.white)
                        
                        Text(subtitleText)
                            .font(.system(size: 10))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    // Count Badge
                    Text("\(filteredLogs.count)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(.white.opacity(0.6))
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding()
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            
            // MARK: - Expanded Content
            if isExpanded {
                VStack(spacing: 0) {
                    if filteredLogs.isEmpty {
                        emptyStateView
                    } else {
                        ForEach(filteredLogs) { log in
                            HistoryRow(log: log)
                            
                            if log.id != filteredLogs.last?.id {
                                Divider().padding(.horizontal)
                            }
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
                .padding(.top, 8)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
    }
    
    private var iconName: String {
        switch timeframe {
        case "Daily": return "sun.max.fill"
        case "Weekly": return "calendar"
        default: return "archivebox.fill"
        }
    }
    
    private var subtitleText: String {
        let count = filteredLogs.filter { $0.isSufficient }.count
        return "\(count) Goals Met"
    }
    
    private var emptyStateView: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.title)
                    .foregroundStyle(.tertiary)
                Text("No \(timeframe.lowercased()) reports yet.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(32)
            Spacer()
        }
    }
}
