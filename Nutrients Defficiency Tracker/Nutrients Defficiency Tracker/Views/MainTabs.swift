//
//  MainTabs.swift
//  Nutrients Defficiency Tracker

//  This file holds the two core tabs of the application. MainTabs serves as a middle main that allows for the
//  onboarding decision logic to be better handled and offloads Tabular view logic off of ContentView

//  Created by Anthony Blazer.
//


import SwiftUI

struct MainTabs: View {
    
    var body: some View {
        TabView { // Use Swift's native tabular outline
            
        Dashboard() // Bring in Dashbord and give is an icon and tab view name
            .tabItem {
                Label("Dashboard", systemImage: "chart.bar.fill")
            }

            Settings() // Bring in Settings and give is an icon and tab view name
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}
