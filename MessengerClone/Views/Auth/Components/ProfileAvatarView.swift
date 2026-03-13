//
//  ProfileAvatarView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct ProfileAvatarView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.2),
                            Color.purple.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 120)

          
            Circle()
                .fill(Color.blue)
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: "camera.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                )
                .offset(x: 6, y: 6)
        }
        .shadow(
            color: Color.blue.opacity(0.25),
            radius: 10,
            x: 0,
            y: 6
        )
    }
}

