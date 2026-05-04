//
//  NutrientChartView.swift
//  Nutrients Deficiency Tracker
//
//  This component visualizes micronutrient intake over time using Swift Charts.
//  It supports interactive data selection, goal/limit visual cues, and a
//  comparative view against a previous period (Yesterday, Last Week, etc.).
//
//  Created by Anthony Blazer.
//

import SwiftUI
import Charts

struct NutrientChartView: View {
    let currentData: [ChartDataPoint]
    let previousData: [ChartDataPoint]
    let goal: Double
    let upperLimit: Double
    let max: Double
    let gradient: LinearGradient
    let unit: String
    let selectedRange: String

    @State private var selectedDate: Date?

    // Determines bar width to maintain visual balance across different time scales.
    var barWidth: MarkDimension {
        selectedRange == "Month" ? .fixed(40) : .fixed(12)
    }
    
    // Snaps the user's touch selection to the nearest actual data point for precise feedback.
    var selectedPoint: ChartDataPoint? {
        guard let selectedDate else { return nil }
        return currentData.min(by: {
            abs($0.date.timeIntervalSince(selectedDate)) < abs($1.date.timeIntervalSince(selectedDate))
        })
    }
    
    // Ensures the "Today" chart always spans a full 24-hour window regardless of data presence.
    var todayRange: ClosedRange<Date> {
        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!
        return start...end
    }

    var body: some View {
        VStack(spacing: 20) {
            
            // MARK: Current Period Chart
            // The primary visualization showing current progress and safety limits.
            VStack(alignment: .leading, spacing: 12) {
                chartHeader(title: "Current Period", point: selectedPoint, isCurrent: true)
                
                Chart {
                    // Safety Zone - Visualizes the "Upper Limit" to "Max" range in light red.
                    RectangleMark(yStart: .value("UL", upperLimit), yEnd: .value("Max", max))
                        .foregroundStyle(.red.opacity(0.08))
                    
                    ForEach(currentData) { point in
                        BarMark(
                            x: .value("Time", point.date, unit: getStrideUnit()),
                            y: .value("Intake", point.value),
                            width: barWidth
                        )
                        .foregroundStyle(gradient)
                        .cornerRadius(4)
                        // Dims other bars when a specific point is selected/focused.
                        .opacity(isFocused(point) ? 1.0 : 0.3)
                    }
                    
                    // Daily Goal Reference Line
                    RuleMark(y: .value("Goal", goal))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 3]))
                        .foregroundStyle(.secondary.opacity(0.6))
                }
                // Conditional scale locking for consistent 24h Today view.
                .if(selectedRange == "Today") { view in
                    view.chartXScale(domain: todayRange)
                }
                .chartXSelection(value: $selectedDate)
                .modifier(BaseChartStyle(unit: unit, selectedRange: selectedRange))
                .frame(height: 180)
            }

            // Comparative Divider
            HStack {
                Text("VERSUS PREVIOUS")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.tertiary)
                Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [2])).frame(height: 1).foregroundStyle(.tertiary)
            }

            // MARK: Previous Period Chart
            // A secondary, de-emphasized chart to compare current performance with history.
            VStack(alignment: .leading, spacing: 12) {
                chartHeader(title: "Previous Period", point: nil, isCurrent: false)
                
                Chart {
                    ForEach(previousData) { point in
                        // When viewing 'Today', we align yesterday's timestamps onto today's axis so bars line up vertically for direct comparison.
                        BarMark(
                            x: .value("Time", alignToToday(point.date), unit: getStrideUnit()),
                            y: .value("Intake", point.value),
                            width: selectedRange == "Month" ? .fixed(20) : .fixed(8)
                        )
                        .foregroundStyle(.gray.secondary)
                        .opacity(0.3)
                        .cornerRadius(2)
                    }
                }
                .if(selectedRange == "Today") { view in
                    view.chartXScale(domain: todayRange)
                }
                .modifier(BaseChartStyle(unit: unit, selectedRange: selectedRange))
                .frame(height: 80)
            }
        }
        .padding(20)
        .background(RoundedRectangle(cornerRadius: 24).fill(Color(.secondarySystemGroupedBackground)))
    }
    
    // Returns the appropriate calendar component for X-axis striding.
    private func getStrideUnit() -> Calendar.Component {
        switch selectedRange {
        case "Today": return .hour
        case "Month": return .weekOfYear
        default: return .day
        }
    }

    // Aligns historical timestamps to current date for visual comparison in the "Today" view.
    // Ex. previous will be "05/01-05/06" and current will be "05/07-05/13"
    private func alignToToday(_ date: Date) -> Date {
        guard selectedRange == "Today" else { return date }
        let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        return Calendar.current.date(bySettingHour: timeComponents.hour ?? 0,
                                     minute: timeComponents.minute ?? 0,
                                     second: 0,
                                     of: .now) ?? date
    }
}

// MARK: - Styling & Components
struct BaseChartStyle: ViewModifier {
    let unit: String
    let selectedRange: String

    func body(content: Content) -> some View {
        content
            .chartXAxis {
                if selectedRange == "Today" {
                    AxisMarks(values: .stride(by: .hour, count: 6)) { value in
                        AxisGridLine().foregroundStyle(.gray.opacity(0.05))
                        AxisValueLabel(format: .dateTime.hour())
                            .font(.system(size: 10, weight: .bold))
                    }
                } else if selectedRange == "Week" {
                    AxisMarks(values: .stride(by: .day)) { _ in
                        AxisGridLine().foregroundStyle(.clear)
                        AxisValueLabel(format: .dateTime.weekday(.abbreviated), centered: true)
                            .font(.system(size: 10, weight: .bold))
                    }
                } else if selectedRange == "Month" {
                    AxisMarks(values: .stride(by: .day, count: 7)) { _ in
                        AxisGridLine().foregroundStyle(.clear)
                        AxisValueLabel(format: .dateTime.day().month(), centered: true)
                            .font(.system(size: 10, weight: .bold))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine().foregroundStyle(.gray.opacity(0.05))
                    AxisValueLabel {
                        if let doubleVal = value.as(Double.self) {
                            Text("\(Int(doubleVal))").font(.system(size: 8, design: .monospaced))
                        }
                    }
                }
            }
    }
}

extension NutrientChartView {
    private func isFocused(_ point: ChartDataPoint) -> Bool {
        guard let selectedPoint else { return true }
        return Calendar.current.isDate(point.date, inSameDayAs: selectedPoint.date)
    }
    
    @ViewBuilder
    private func chartHeader(title: String, point: ChartDataPoint?, isCurrent: Bool) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.system(.caption, design: .rounded).bold())
                .foregroundStyle(isCurrent ? .primary : .secondary)
            
            Spacer()
            
            if let point = point {
                HStack(spacing: 4) {
                    Text("\(Int(point.value))")
                        .font(.system(.subheadline, design: .monospaced).bold())
                    Text(unit)
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition { transform(self) } else { self }
    }
}
