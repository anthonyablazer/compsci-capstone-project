//
//  FeedbackView.swift
//  Nutrients Deficiency Tracker

//  A comprehensive detail view for a specific micronutrient, presenting biological
//  roles, chemical interactions (synergy/interference), and dietary presences.
//  It is here where information is linked to the NIH for further research.
//  Created by Anthony Blazer.
//

import SwiftUI

struct NutrientProfileView: View {
    let profile: Micronutrient
    
    // Tracks which help topic (Synergy or Interference) the user is currently viewing.
    @State private var activeHelpTopic: HelpTopic?
    
    // Dynamic lookup for medical data. The fallback to "Iron" ensures the UI doesn't crash
    private var science: NutrientFactSheet {
        NutrientRegistry.data[profile.name] ?? NutrientRegistry.data["Iron"]!
    }
    
    // Enum to encapsulate localized strings and logic for educational tooltips.
    enum HelpTopic: Identifiable {
        case synergy, interference
        var id: Self { self }
        
        var title: String { self == .synergy ? "Synergy" : "Interference" }
        var message: String {
            self == .synergy
            ? "Synergy refers to nutrients or compounds that work together to improve the absorption and effectiveness of this nutrient in your body."
            : "Interference refers to substances that can inhibit or slow down the absorption of this nutrient, ranging from a minimal to a notable extent."
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // MARK: header and Identity
            // Displays the specific nutrient name and a periodic-table style symbol.
            // Vitamins will get an abbreviation; Minerals will get their periodic symbol
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nutrient Profile")
                        .font(.system(.caption, design: .rounded).bold())
                        .foregroundStyle(profile.gradient)
                        .textCase(.uppercase)
                        .tracking(1.2)
                    Text(science.name)
                        .font(.system(.title, design: .rounded).bold())
                }
                Spacer()
                
                // Periodic Table Style Symbol (e.g., Fe, Mg)
                Text(profile.symbol)
                    .font(.system(.title3, design: .monospaced).bold())
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(profile.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // MARK: Bodily role
            // Provides a brief, high-level summary of what the nutrient does in the body.
            Text(science.biochemicalRole)
                .font(.system(.callout, design: .rounded))
                .lineSpacing(4)
                .foregroundStyle(.secondary)

            // MARK: interaction grid
            // Displays Synergy/Interference side-by-side
            HStack(spacing: 12) {
                InfoCell(title: "Synergy", value: science.synergy, icon: "plus.circle.fill", color: .green, helpAction: { activeHelpTopic = .synergy })
                InfoCell(title: "Interference", value: science.interference, icon: "minus.circle.fill", color: .red, helpAction: { activeHelpTopic = .interference })
            }

            // MARK: Absorption
            // Educational callout explaining the "how" and "why" behind nutrient bioavailability.
            VStack(alignment: .leading, spacing: 8) {
                Label("ABSORPTION NOTES", systemImage: "info.circle.fill")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(.primary.opacity(0.6))
                
                Text(science.absorptionScience)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.primary.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(Color(.tertiarySystemGroupedBackground))
            .cornerRadius(16)

            // MARK: dieatary information
            // A horizontal scrolling list of capsule-style tags for common food sources.
            Text("Common Dietary Sources")
                .font(.system(.headline, design: .rounded))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(science.highDensityFoods) { food in
                        VStack(alignment: .leading) {
                            Text(food.name)
                                .font(.system(.subheadline, design: .rounded).bold())
                            Text(food.category)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.tertiarySystemGroupedBackground))
                        .clipShape(Capsule())
                    }
                }
            }

            // MARK: Disclaimer and NIH Citation/Link
            VStack(alignment: .center, spacing: 8) {
                Divider()
                // Educational warning
                Text("Educational information only. Consult a healthcare provider for medical advice.")
                    .font(.system(size: 10))
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.tertiary)
                // Link to NIH's page for the current nutrient
                Link(destination: URL(string: science.medicalLink)!) {
                    Text("NIH Clinical Fact Sheet")
                        .font(.caption2.bold())
                        .underline()
                        .foregroundStyle(profile.gradient)
                }
            }
            .padding(.top, 10)
        }
        .padding(24)
        .background(RoundedRectangle(cornerRadius: 30).fill(Color(.secondarySystemGroupedBackground)))
        // Dynamic alert presentation based on the selected HelpTopic.
        .alert(item: $activeHelpTopic) { topic in
            Alert(
                title: Text(topic.title),
                message: Text(topic.message),
                dismissButton: .default(Text("Got it"))
            )
        }
    }
}

// MARK: - Reusable Info Cell Component

struct InfoCell: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    // Optional closure executed when the help button is tapped.
    var helpAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(color)
                
                Spacer()
                
                if helpAction != nil {
                    Button {
                        helpAction?()
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain) // Prevents the button from triggering the background color highlights.
                }
            }
            
            Text(value)
                .font(.system(.subheadline, design: .rounded).bold())
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(16)
    }
}
