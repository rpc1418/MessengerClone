//
//  PrimaryButton.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

/// Main action button used across the app
struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .font(.system(size: 17))
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    // Gradient gives a premium feel
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(18)
                .shadow(
                    // Button elevation
                    color: Color.blue.opacity(0.35),
                    radius: 10,
                    x: 0,
                    y: 6
                )
        }
    }
}
