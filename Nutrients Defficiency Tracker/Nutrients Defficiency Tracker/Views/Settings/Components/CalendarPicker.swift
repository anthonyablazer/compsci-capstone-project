//
//  CalendarPicker.swift
//  Nutrients Deficiency Tracker
//
//  A custom grid-based selector for monthly notification scheduling.  This provides a more intuitive interface than a standard picker for selecting a specific day of the month (1-31).
//
//  Created by Anthony Blazer.
//

import SwiftUI
import SwiftData

struct CalendarPicker: View {
    // The day of the month selected (1-31), bound to the parent's data model.
    @Binding var selectedDay: Int
    var syncAction: () -> Void
    
    // Defines a 7-column layout to mimic a standard calendar week view.
    let calendarColumns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Day of Month")
                .font(.caption.bold())
                .foregroundStyle(.secondary)
            
            // MARK: Day Selection Grid
            // Uses a LazyVGrid for efficient rendering of the 31 interactive circles.
            LazyVGrid(columns: calendarColumns, spacing: 6) {
                ForEach(1...31, id: \.self) { day in
                    Text("\(day)")
                        .font(.footnote.bold())
                        .frame(width: 32, height: 32)
                        // Visual feedback: High-contrast blue for selection,
                        // subtle fill for inactive days.
                        .background(selectedDay == day ? Color.blue : Color(.tertiarySystemFill))
                        .foregroundColor(selectedDay == day ? .white : .primary)
                        .clipShape(Circle())
                        .onTapGesture {
                            // Haptic feedback could be added here for a more premium feel.
                            selectedDay = day
                            syncAction()
                        }
                }
            }
        }
    }
}
