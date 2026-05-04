//
//  ContentView.swift
//  Nutrients Defficiency Tracker

//  This file acts the main logical flow manager for the application. Determined here is whether the application should enter the Onboarding process or the main application.

//  Created by Anthony Blazer.

/*
 Put in final capstone presentation to poke fun at Bogert: "Micronutrient inadequacies may also have important implications for long-term health and increase one’s risk for chronic diseases like cancer"
        from: https://lpi.oregonstate.edu/mic/micronutrient-inadequacies/overview#toc-micronutrient-deficiencies-and-inadequacies-
 */

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext // Access the SwidtData models
    @Query private var profiles: [UserProfile] // Get all stored UserProfile's stored.
    
    // This is a universal singleton variable that is crucial to determining whether the user needs to complete Onboarding.
    @AppStorage("completed_onboarding") var completedOnboarding: Bool = false
    // This variable decides (when the application is force quit) if the application should show a splash screen.
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            // Force quit? Show splash screen before entering the app.
            if showSplash {
                Splash()
                    .transition(.opacity)
            } else {
                // Has the user completed onboarding? If so, enter the dashboard.
                if completedOnboarding, let profile = profiles.first {
                    // Entry point for the main app
                    MainTabs()
                        .environment(profile)
                // If not, make the user complete onboarding.
                } else {
                    // Entry point for onboarding
                    Onboarding()
                }
            }
        }
        // When the app is first loaded, ensure the needed Micronutrient model entries have been added to the Micronutrient model.
        .onAppear {
            initializeAppData()
        }
    }
    
    // Wrapper function for seedNutrients(), ensuring all Micronutrients are in the model for application utility.
    private func initializeAppData() {
        // Seed nutrients
        DataSeeder.seedNutrients(container: modelContext.container)
        
        // Splash delay with smooth transition
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}
