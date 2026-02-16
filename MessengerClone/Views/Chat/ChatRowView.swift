//
//  ChatRowView.swift
//  MessengerClone
//
//  Created by rentamac on 2/12/26.
//
import SwiftUI
import FirebaseFirestore

struct ChatRowView: View {
    
    let chat: Chat

    var body: some View {
        HStack(spacing: 12) {

            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 3) {

                Text(chat.name ?? "")
                    .font(.system(size: 16, weight: .semibold))

                Text("\(chat.lastMessage) · \(chat.lastUpdated.dateValue().messengerFormattedString())")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            // ✔ Tick mark
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18))
                .foregroundColor(.gray.opacity(0.6))
        }
        .padding(.vertical, 4) // reduced the padding
        //.listRowSeparator(.hidden)//remove the row seperator
    }
}
