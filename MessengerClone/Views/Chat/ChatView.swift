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
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authViewModel: AuthViewModel
    let chatService = ChatService()
    
    
    @FocusState private var isInputFocused: Bool
    @State private var inputHeight: CGFloat = 40
    private var canSend: Bool {
        !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
     
    @State var showAlert: Bool = false
    
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
                
                    
                    
                    HStack {
                        Image(systemName: "chevron.left")
                            .padding()
                        .onTapGesture {
                            router.goBack()
                        }
                        Text(chatViewModel.chatName)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Image(systemName: "phone.fill")
                                .onTapGesture {
                                    
                                        showAlert = true
                                    
                                }
                            
                            Image(systemName: "video.fill")
                                .onTapGesture {
                                    
                                        showAlert = true
                                    
                                }
                        }
                    }
                
                

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
                                    senderName: chatViewModel.getName(userId: message.senderID),
                                    participants: chat.participants
                                ).environmentObject(chatViewModel)
                                
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
                        chatViewModel.markMessagesRead(allowed: authViewModel.readReceipts)
                    }
                }
                
                HStack {
                     VStack(spacing: 0) {
                        
                        Divider()
                        
                        HStack(alignment: .bottom, spacing: 10) {
                            
                            
                            if newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                                HStack(spacing: 16) {
                                    
                                    Button {
                                       
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 22))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Button {
                                       
                                    } label: {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    Button {
                                       
                                    } label: {
                                        Image(systemName: "mic.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            
                          
                            TextField("Aa", text: $newMessage, axis: .vertical)
                                .focused($isInputFocused)
                                .lineLimit(1...3)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
//                                .clipShape(Capsule())
                            
                            
                            if newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                
                                Button {
                                    Task {
                                        do {
                                            try await chatService.sendMessage(
                                                chatID: chat.id,
                                                senderID: currentUserID,
                                                text: "👍"   
                                            )
                                            newMessage = ""
                                        } catch {
                                            print("Error sending message:", error.localizedDescription)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .font(.system(size: 22))
                                        .foregroundColor(.blue)
                                }
                                
                            } else {
                                
                                Button {
                                    Task {
                                        do {
                                            try await chatService.sendMessage(
                                                chatID: chat.id,
                                                senderID: currentUserID,
                                                text: newMessage
                                            )
                                            newMessage = ""
                                        } catch {
                                            print("Error sending message:", error.localizedDescription)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "paperplane.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground))
                    }



                }
                .padding()
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                chatViewModel.startListeningToMsgs()
            }
            
            .onDisappear {
                chatViewModel.stopListening()
            }
            .alert("Call not Supported", isPresented: $showAlert) {
                Button("Cancel", role: .cancel) {showAlert.toggle() }
                } message: {
                    Text("This action cannot be done.")
                }
        } else {
            VStack {
                Text("Loading...")
            }
        }
        
        
    }
}
