//
//  HomeChatRowView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct HomeChatRowView: View {

    let chat: MockChat

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.black.opacity(0.7))
                .frame(width: 55, height: 55)

            VStack(alignment: .leading, spacing: 4) {
                Text(chat.name)
                    .font(.headline)

                Text("\(chat.lastMessage) · \(chat.time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}

