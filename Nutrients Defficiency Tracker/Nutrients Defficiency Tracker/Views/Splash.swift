//
//  Splash.swift
//  Nutrients Defficiency Tracker

//  This is a simple screen that is shown to the user for a brief time to allow the application time to load and to signal app restart.

//  Created by Anthony Blazer.
//

import SwiftUI

struct Splash: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            Text("Small But Essential")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 16)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}
