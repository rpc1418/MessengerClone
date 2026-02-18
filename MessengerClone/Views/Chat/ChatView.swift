//
//  Chatview.swift
//  MessengerClone
//
//  Created by rentamac on 2/17/26.
//

import SwiftUI

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    let chat: Chat
    let currentUserID: String
    @StateObject var chatViewModel: ChatViewModel
    @State private var newMessage: String = ""
    
    let chatService = ChatService()
    
    
    @FocusState private var isInputFocused: Bool
    @State private var inputHeight: CGFloat = 40
    private var canSend: Bool {
        !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    
    init(chat: Chat, currentUserID: String) {
            self.chat = chat
            self.currentUserID = currentUserID
            
            _chatViewModel = StateObject(
                wrappedValue: ChatViewModel(
                    chat: chat,
                    CurUserId: currentUserID
                )
            )
        }
    
    var body: some View {
        if(!chatViewModel.isLoading){
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(chatViewModel.messages.indices, id: \.self) { index in
                                let message = chatViewModel.messages[index]
                                let isCurrentUser = message.senderID == currentUserID

                                let showName: Bool = {
                                    if isCurrentUser { return false } // your own messages, no name
                                    if index == chatViewModel.messages.count - 1 { return true } // last message in list
                                    let nextMessage = chatViewModel.messages[index + 1]
                                    return nextMessage.senderID != message.senderID
                                }()



                                MessageRowView(
                                    message: message,
                                    showName: showName,
                                    isCurrentUser: isCurrentUser,
                                    senderName: chatViewModel.getName(userId: message.senderID)
                                )
                            }


                        }
                        .padding()
                    }
                    .onChange(of: chatViewModel.messages) { _ in
                        if let last = chatViewModel.messages.last {
                            withAnimation {
                                scrollView.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                HStack {
                    VStack(spacing: 0) {
                        Divider()
                        
                        HStack(alignment: .bottom, spacing: 8) {
                            
                           
                            Button {
                                isInputFocused = true
                            } label: {
                                Image(systemName: "face.smiling")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                            }
                            
                            
                            ZStack(alignment: .leading) {
                                if newMessage.isEmpty {
                                    Text("Type a message...")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                }
                                
                                TextEditor(text: $newMessage)
                                    .focused($isInputFocused)
                                    .frame(height: 28)
                                    .padding(4)
                                    .background(Color.clear)
                            }
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            
                            Button {
                                Task{
                                    do{
                                       try await chatService.sendMessage(chatID: chat.id, senderID: currentUserID, text: newMessage)
                                        newMessage = ""
                                    }
                                    catch{
                                        print("error sending message:" ,error.localizedDescription)
                                    }
                                }
                               
                            } label: {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(canSend ? .white : .gray)
                                    .padding(10)
                                    .background(canSend ? Color.blue : Color(.systemGray5))
                                    .clipShape(Circle())
                            }
                            .disabled(!canSend)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                    }

                }
                .padding()
            }
            .navigationTitle(chatViewModel.chatName)
            .onAppear {
                chatViewModel.startListeningToMsgs()
            }
            .onDisappear {
                chatViewModel.stopListening()
            }
        } else {
            VStack {
                Text("Loading...")
            }
        }
        
        
    }
}
