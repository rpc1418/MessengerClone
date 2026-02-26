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
import PhotosUI

struct ChatView: View {
    let chat: Chat
    let currentUserID: String
    
    @StateObject var chatViewModel: ChatViewModel
    @State private var newMessage: String = ""
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authViewModel: AuthViewModel
    let chatService = ChatService()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showDocumentPicker = false
    @State private var selectedDocumentURL: URL?
    
    @FocusState private var isInputFocused: Bool
    @State private var activeAlert: AlertType?
    
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
        if !chatViewModel.isLoading {
            VStack(spacing: 0) {
                
                topBar
                
                messagesView
                
                inputBar
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                chatViewModel.startListeningToMsgs()
            }
            .onDisappear {
                chatViewModel.stopListening()
            }
            .alert(item: $activeAlert) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .onChange(of: selectedPhoto) { newItem in
                guard let newItem else { return }
                
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        await chatService.uploadAndSendImage(chatId: chat.id, senderId: currentUserID, data: data)
                    }
                }
            }
            .fileImporter(
                isPresented: $showDocumentPicker,
                allowedContentTypes: [.pdf, .plainText, .data, .image, .item],
                allowsMultipleSelection: false
            ) { result in
                
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    
                    Task {
                        await chatService.uploadAndSendDocument(
                            chatId: chat.id,
                            senderId: currentUserID,
                            fileURL: url
                        )
                    }
                    
                case .failure(let error):
                    print("Document picker error:", error.localizedDescription)
                }
            }
        } else {
            VStack {
                Text("Loading...")
            }
        }
    }

    
    private var topBar: some View {
        HStack {
            Image(systemName: "chevron.left")
                .padding()
                .onTapGesture {
                    router.goBack()
                }
            
            Text(chatViewModel.chatName)
                .font(.headline)
            
            Spacer()
            
            HStack(spacing: 16) {
                Image(systemName: "phone.fill")
                    .onTapGesture {
                        activeAlert = .phone
                    }
                
                Image(systemName: "video.fill")
                    .onTapGesture {
                        activeAlert = .video
                    }
            }
        }
        .padding(.horizontal)
    }

    
    private var messagesView: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(chatViewModel.messages.indices, id: \.self) { index in
                        
                        let message = chatViewModel.messages[index]
                        let isCurrentUser = message.senderID == currentUserID
                        
                        let showName: Bool = {
                            if isCurrentUser { return false }
                            if index == chatViewModel.messages.count - 1 { return true }
                            let nextMessage = chatViewModel.messages[index + 1]
                            return nextMessage.senderID != message.senderID
                        }()
                        
                        MessageRowView(
                            message: message,
                            showName: showName,
                            isCurrentUser: isCurrentUser,
                            senderName: chatViewModel.getName(userId: message.senderID),
                            participants: chat.participants
                        )
                        .environmentObject(chatViewModel)
                        .id(message.id)
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
    }

    
    private var inputBar: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(alignment: .bottom, spacing: 10) {
                
                if newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    
                    HStack(spacing: 16) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                            .onTapGesture {
                            showDocumentPicker = true
                            }
                        
                        Image(systemName: "camera.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                activeAlert = .camera
                            }
                        
                        PhotosPicker(
                            selection: $selectedPhoto,
                            matching: .images
                        ) {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        }
                            
                        
                        Image(systemName: "mic.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                activeAlert = .mic
                            }
                    }
                }
                
                TextField("Aa", text: $newMessage, axis: .vertical)
                    .focused($isInputFocused)
                    .lineLimit(1...3)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                
                if canSend {
                    Button {
                        sendMessage(text: newMessage)
                        newMessage = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.blue)
                    }
                } else {
                    Button {
                        sendMessage(text: "👍")
                    } label: {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
        }
    }
    
    private func sendMessage(text: String) {
        Task {
            do {
                try await chatService.sendMessage(
                    chatID: chat.id,
                    senderID: currentUserID,
                    text: text
                )
            } catch {
                print("Error sending message:", error.localizedDescription)
            }
        }
    }
}
