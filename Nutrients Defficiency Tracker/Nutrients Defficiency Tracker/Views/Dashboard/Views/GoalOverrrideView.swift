//
//  GoalOverrideView.swift
//  Nutrients Defficiency Tracker

// This file contains a view that allows a user to update their target intake goal for a given micronutrient.

//  Created by Anthony Blazer.
//

import SwiftUI
import SwiftData

struct GoalOverrideView: View {
    // The micronutrient entry to update
    @Bindable var nutrient: Micronutrient
    // Access the user profile.
    @Query private var userProfiles: [UserProfile]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $nutrient.isManualGoal) {
                        Label("Manual Editing", systemImage: nutrient.isManualGoal ? "lock.open.fill" : "lock.fill")
                            .foregroundStyle(nutrient.isManualGoal ? .orange : .blue)
                    }
                    .tint(.orange)
                } header: {
                    Text("Settings")
                }

                Section {
                    HStack {
                        Text("Daily Goal")
                            .foregroundStyle(nutrient.isManualGoal ? .primary : .secondary)
                        Spacer()
                        TextField("Value", value: $nutrient.dailyGoal, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .font(.headline)
                            .disabled(!nutrient.isManualGoal) // 2) Logic: Typing disabled if toggle off
                            .opacity(nutrient.isManualGoal ? 1.0 : 0.4)
                        Text(nutrient.unit).foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Target")
                }
                
                // 1) Added back the Reset to RDA
                if let user = userProfiles.first {
                    Section {
                        let rda = ScienceProvider.getRDA(for: nutrient.name, profile: user)
                        Button("Reset to Recommended (\(Int(rda))\(nutrient.unit))") {
                            nutrient.dailyGoal = rda
                            nutrient.isManualGoal = false
                            dismiss()
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.blue)
                    }
                }
            }
            .navigationTitle("\(nutrient.name) Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") { dismiss() }
            }
        }
        .presentationDetents([.medium])
    }
}
