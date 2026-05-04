//
//  AuthorizationView.swift
//  Nutrients Deficiency Tracker
//
//  This view manages the initial onboarding permissions. It ensures the app
//  has the necessary access to HealthKit for data reading and the Notification
//  Center for the flaship alert system.
//
//  Created by Anthony Blazer.
//

import SwiftUI
import HealthKit

struct AuthorizationView: View {
    var onNext: () -> Void
    
    // Monitors notification status via a singleton manager.
    @StateObject private var notifications = NotificationManager.instance
    @State private var healthStatus: PermissionStatus = .notDetermined
    
    // Internal state tracking for HealthKit flow to update UI dynamically.
    enum PermissionStatus {
        case notDetermined, loading, authorized, denied
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // MARK: - 1. EXPLANATORY HEADER
            // High-level statement explaining WHY these permissions matter.
            VStack(spacing: 8) {
                Text("Secure Connectivity")
                    .font(.title2).bold()
                Text("To track your nutrition accurately, we need to connect with your device features.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)

            // MARK: - 2. PERMISSION TILES
            // Interactive cards for requesting system-level access.
            VStack(spacing: 16) {
                // HealthKit Permission: Required for core app functionality (data ingestion).
                PermissionTile(
                    title: "Health Data",
                    subtitle: "Read dietary iron, vitamins, and more.",
                    icon: "heart.text.square.fill",
                    color: .red,
                    status: healthStatus == .authorized ? .granted : .idle
                ) {
                    requestHealth()
                }

                // Notification Permission: Secondary, but vital for daily engagement and safety alerts.
                PermissionTile(
                    title: "Notifications",
                    subtitle: "Daily reminders and deficiency alerts.",
                    icon: "bell.badge.fill",
                    color: .blue,
                    status: notifications.authStatus == .authorized ? .granted : .idle
                ) {
                    notifications.requestPermission()
                }
            }
            .padding()

            Spacer()

            // MARK: Navigation Action
            // Context-aware button text that changes based on successful authorization.
            Button(action: onNext) {
                Text(healthStatus == .authorized ? "Everything looks good!" : "Maybe Later")
                    .font(.headline)
                    .foregroundStyle(healthStatus == .authorized ? .blue : .secondary)
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            // Refresh notification state immediately when the view appears.
            notifications.checkPermission()
        }
    }
    
    // Triggers the HealthKit authorization modal and enables background delivery
    // for all tracked nutrients upon success.
    private func requestHealth() {
        healthStatus = .loading
        HealthKitManager.shared.requestAuthorization { success in
            // UI updates are handled on a background thread by HK, so Ensure Main Thread
            // if you add @Published or @State changes that affect the UI.
            healthStatus = success ? .authorized : .denied
            if success {
                // Iteratively enable background observers for each nutrient type.
                for type in HealthKitManager.shared.nutrientTypes {
                    if let qtyType = type as? HKSampleType {
                        HealthKitManager.shared.enableBackgroundDelivery(for: qtyType)
                    }
                }
            }
        }
    }
}

// MARK: - Subcomponent: PermissionTile

struct PermissionTile: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let status: TileStatus
    let action: () -> Void
    
    enum TileStatus { case idle, granted }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Visual Branding for the permission category
                Image(systemName: icon)
                    .font(.title)
                    .foregroundStyle(.white)
                    .frame(width: 50, height: 50)
                    .background(color)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline).foregroundStyle(.primary)
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Feedback: Visual confirmation once permission is granted.
                Image(systemName: status == .granted ? "checkmark.circle.fill" : "chevron.right")
                    .foregroundStyle(status == .granted ? .green : .secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(16)
        }
        // Prevents re-triggering the system prompt once already granted.
        .disabled(status == .granted)
    }
}
