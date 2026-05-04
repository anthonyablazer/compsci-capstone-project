//
//  Onboarding.swift
//  Nutrients Deficiency Tracker
//
//  This is the main container for the app's onboarding flow. It manages
//  the state machine for navigation, input validation, and the final
//  persistence of the user profile and personalized nutrient goals.
//
//  Created by Anthony Blazer.
//

import SwiftUI
import SwiftData

// MARK: Onboarding State Management
enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case disclaimer = 1
    case profile = 2
    case permissions = 3
    case finalize = 4
    
    // Calculates progress percentage (0.0 to 1.0) for the ProgressView.
    var progress: Double {
        Double(self.rawValue + 1) / Double(OnboardingStep.allCases.count)
    }
}

struct Onboarding: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentStep: OnboardingStep = .welcome
    @State private var profile = UserProfile() // Temporary local state until saved
    
    // UI State: Persisted flag to ensure onboarding only runs once.
    @AppStorage("completed_onboarding") var completedOnboarding: Bool = false
    
    var body: some View {
        VStack {
            // MARK: Progress header bar
            // Provides immediate visual feedback on remaining steps.
            HStack {
                ProgressView(value: currentStep.progress)
                    .tint(.blue)
                    .animation(.spring, value: currentStep)
                
                Text("\(Int(currentStep.progress * 100))%")
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // MARK: Step Content
            // Asymmetric transitions create a smooth "forward-moving" UI feel.
            ZStack {
                switch currentStep {
                case .welcome:
                    IntroductionView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .disclaimer:
                    DisclaimerView()
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .profile:
                    ProfileSetupView(profile: profile)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .permissions:
                    AuthorizationView(onNext: nextStep)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                case .finalize:
                    WelcomeView(name: profile.name)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
            
            Spacer()
            
            // MARK: Navigation Controls
            // The button dynamically updates its label based on the context of the step.
            if currentStep != .permissions {
                Button(action: nextStep) {
                    Text(currentStep == .finalize ? "Get Started" : (currentStep == .disclaimer ? "I Understand & Agree" : "Continue"))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                }
                .disabled(!isStepValid) // Safety check for required inputs (like name)
                .opacity(isStepValid ? 1.0 : 0.5)
                .padding(.bottom, 20)
            }
        }
        // Global spring animation for all state-driven UI changes.
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
    }
    
    // MARK: nextStep()
    // Increments the step or triggers the final save if onboarding is complete.
    private func nextStep() {
        if currentStep == .finalize {
            finish()
        } else {
            currentStep = OnboardingStep(rawValue: currentStep.rawValue + 1) ?? .finalize
        }
    }
    
    // Logic-gate for the "Continue" button.
    // Ensures the user cannot proceed without providing vital data.
    private var isStepValid: Bool {
        switch currentStep {
        case .profile:
            return !profile.name.trimmingCharacters(in: .whitespaces).isEmpty
        default:
            return true
        }
    }
    
    // MARK: finish()
    // Finalizes the onboarding by saving the user's data and calculating personalized RDA goals for all nutrients.
    private func finish() {
        // 1. Persist the user profile to SwiftData.
        modelContext.insert(profile)
        
        // 2. Fetch seeded Micronutrients and personalize goals based on the new profile.
        let descriptor = FetchDescriptor<Micronutrient>()
        if let nutrients = try? modelContext.fetch(descriptor) {
            for nutrient in nutrients {
                // Calculation logic derived from the Scientific Provider.
                nutrient.dailyGoal = ScienceProvider.getRDA(for: nutrient.name, profile: profile)
                nutrient.upperLimit = ScienceProvider.getUpperLimit(for: nutrient.name)
            }
        }
        
        // 3. Save context and exit onboarding mode.
        try? modelContext.save()
        
        withAnimation {
            completedOnboarding = true
        }
    }
}
