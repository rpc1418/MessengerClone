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
    let CurUserId: String 

    private var chatName: String {
            if chat.isGroup {
                return chat.name ?? "dummyname"
            } else {
                return chat.participants
                    .filter { $0 != CurUserId }
                    .map { if let user = PersistenceController.shared.fetUserById(id: $0)
                        {return user.fullName}
                        else {
                        print($0)
                        return "dummy"
                    }
                    }
                    .joined(separator: "")
            }
        }
    
    var body: some View {
        HStack(spacing: 12) {
            
            ZStack{
                // Avatar
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 52, height: 52)
                Image(systemName: "person.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(chat.isGroup ? chat.name! : chatName)
                    .font(.system(size: 16, weight: .semibold))
                
                Text("\(chat.lastMessage) · \(chat.lastUpdated.dateValue().messengerFormattedString())")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            
        }
        .padding(.vertical, 4) // reduced the padding
        //.listRowInsets(EdgeInsets())
        //.listRowSeparator(.hidden)//remove the row seperator
    }
}
