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

    var body: some View {
        HStack{
            if(isCurrentUser){
                Spacer()
            }
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
                

                HStack(alignment: .bottom, spacing: 8) {
                    
                    if !isCurrentUser , showName {
                        // Replace with your avatar image logic or placeholder
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .clipShape(Circle())
                    }else{
                        Color.clear
                                .frame(width: 28, height: 28)
                    }
                    VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 2) {
                        
                        Text(message.text)
                            .padding(10)
                            .background(isCurrentUser ? Color.blue.opacity(0.7) : Color.gray.opacity(0.2))
                            .foregroundColor(isCurrentUser ? .white : .black)
                            .cornerRadius(16)
                        HStack{
                            Text(message.timestampFormatted)
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .padding(isCurrentUser ? .trailing : .leading, 6)
                            if showName {
                                Text(senderName)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .padding(isCurrentUser ? .trailing : .leading, 6)
                            }
                        }

                        
                    }
                    
                }
            }
            .id(message.id)
            
            if(!isCurrentUser){
                Spacer()
            }
        }
        
    }
}
