//
//  PrimaryButtons.swift
//  MessengerClone
//
//  Created by rentamac on 2/7/26.
//

import SwiftUI

struct PrimaryButtons: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) { 
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                } else {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.4), radius: 10)
        }
    }
}
