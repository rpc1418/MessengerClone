//
//  MessageView.swift
//  MessengerClone
//
//  Created by rentamac on 17/02/2026.
//

import SwiftUI

struct MessageRowView: View {
    let message: Message
    let showName: Bool
    let isCurrentUser: Bool
    let senderName: String
    let participants: [String]
    @State var showReadByMemebers: Bool = false
    @EnvironmentObject var chatViewModel: ChatViewModel
    
    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
                
                HStack(alignment: .bottom, spacing: 8) {
                    
                    // Sender profile
                    if !isCurrentUser, showName {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                    } else {
                        Color.clear.frame(width: 28, height: 28)
                    }
                    
                    VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
                        
                        // Message bubble
                        Group {
                            if message.text.starts(with: "[image]") {
                                // Image message
                                let imageName = message.text.replacingOccurrences(of: "[image]", with: "")
                                HStack {
                                    Image(systemName: "photo.fill")
                                    Text(imageName)
                                        .lineLimit(1)
                                        .foregroundColor(.blue)
                                }
                            } else if message.text.starts(with: "[file]") {
                                // File message
                                let fileName = message.text.replacingOccurrences(of: "[file]", with: "")
                                HStack {
                                    Image(systemName: "doc.fill")
                                    Text(fileName)
                                        .lineLimit(1)
                                        .foregroundColor(.blue)
                                }
                                .padding(10)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(16)
                            } else {
                                // Text message
                                Text(message.text)
                                    .padding(10)
                                    .background(isCurrentUser ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                                    .cornerRadius(16)
                            }
                        }
                        
                        // Timestamp & sender name / read receipts
                        HStack {
                            Text(message.timestampFormatted)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(isCurrentUser ? .trailing : .leading, 6)
                            
                            if showName {
                                Text(senderName)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .padding(isCurrentUser ? .trailing : .leading, 6)
                            } else if showReadByMemebers {
                                Text("ReadBy:")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .padding(isCurrentUser ? .trailing : .leading, 6)
                            }
                        }
                        
                        // Read by members list
                        if showReadByMemebers {
                            VStack(alignment: .leading, spacing: 4) {
                                let readId: [String] = message.readBy.filter { $0 != chatViewModel.CurUserId }
                                ForEach(readId, id: \.self) { userId in
                                    let name = chatViewModel.participants.first(where: { $0.id == userId })?.name ?? "Unknown"
                                    Text(name)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .padding(isCurrentUser ? .trailing : .leading, 6)
                                }
                            }
                        }
                        
                    } // VStack
                    
                    // Read receipt checkmark
                    if isCurrentUser {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(Set(message.readBy) == Set(participants) ? Color.blue : Color.gray)
                            .onTapGesture {
                                showReadByMemebers.toggle()
                            }
                    }
                    
                } // HStack
            } // VStack
            .id(message.id)
            
            if !isCurrentUser { Spacer() }
        } // HStack
    }
}
