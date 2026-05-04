//
//  ProfileSetupView.swift
//  Nutrients Deficiency Tracker
//
//  This view allows users to create their User Profile so the app can calculate personalized micronutrient goals. By using @Bindable, it directly modifies the UserProfile model in real-time during the onboarding process.
//
//  Created by Anthony Blazer.
//

import SwiftUI

struct ProfileSetupView: View {
    @Bindable var profile: UserProfile
    private let sexes = ["Male", "Female", "Other"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Tell us about yourself")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // MARK: Identity Section
                // Captures the user's name with a visual validation cue (red border) to prevent empty submissions
                VStack(alignment: .leading) {
                    Label("Name", systemImage: "person.fill")
                        .font(.caption).bold().foregroundStyle(.secondary)
                    TextField("Your name", text: $profile.name)
                        .font(.title3)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(profile.name.isEmpty ? Color.red.opacity(0.3) : Color.clear, lineWidth: 2)
                        )
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10)

                // MARK: Biometric Grid
                // Displays age and sex in a side-by-side grid. These factors are
                // key drivers in determining mineral and vitamin requirements.
                HStack(spacing: 15) {
                    // Age Card: Uses a slider for a more touch-friendly mobile experience.
                    StatCard(label: "Age", value: "\(Int(profile.age))", systemImage: "calendar") {
                        Slider(value: $profile.age, in: 18...100, step: 1)
                    }
                    
                    VStack(alignment: .leading) {
                        Label("Sex", systemImage: "figure.arms.open")
                            .font(.caption).bold().foregroundStyle(.secondary)
                        Picker("Sex", selection: $profile.gender) {
                            ForEach(sexes, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.menu)
                        .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.05), radius: 10)
                }
                
                // MARK: Physical Metrics
                // Weight and Height inputs. Weight is particularly important for nutrients where the RDA is calculated per kilogram of body mass.
                VStack(spacing: 20) {
                    MetricInput(label: "Weight", value: $profile.weight, unit: "lbs", icon: "scalemass.fill")
                    Divider()
                    MetricInput(label: "Height", value: $profile.height, unit: "in", icon: "ruler.fill")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.05), radius: 10)
            }
            .padding()
        }
    }
}

// MARK: - Helper Components

// A reusable card for displaying a label and a custom input control.
struct StatCard<Content: View>: View {
    let label: String
    let value: String
    let systemImage: String
    let content: Content
    
    init(label: String, value: String, systemImage: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.value = value
        self.systemImage = systemImage
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label(label, systemImage: systemImage)
                    .font(.caption).bold().foregroundStyle(.secondary)
                Spacer()
                Text(value).bold().foregroundStyle(.blue)
            }
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}

// A standardized row for numerical metric input with unit labels.
struct MetricInput: View {
    let label: String
    @Binding var value: Double
    let unit: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon).foregroundStyle(.blue).frame(width: 24)
            Text(label).bold()
            Spacer()
            TextField("0", value: $value, format: .number)
                .keyboardType(.decimalPad) // Optimized for numerical data entry
                .multilineTextAlignment(.trailing)
                .font(.system(.body, design: .monospaced))
                .frame(width: 60)
            Text(unit).foregroundStyle(.secondary).font(.caption)
        }
    }
}
