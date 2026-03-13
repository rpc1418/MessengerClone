//
//  InputCard.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct InputCard<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.secondarySystemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.gray.opacity(0.08), lineWidth: 1)
        )
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}
