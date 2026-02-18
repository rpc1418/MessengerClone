//
//  ChatViewModel.swift
//  MessengerClone
//
//  Created by rentamac on 2/17/26.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    let chat: Chat
    let CurUserId: String
    @Published var messages: [Message] = []
    @Published var participants: [chatuser] = []
    private let chatService = ChatService()
    private var messageStreamTask: Task<Void, Never>?
    var isLoading: Bool = true
    var chatName: String = ""
    
    init(chat: Chat, CurUserId: String){
        self.chat = chat
        self.CurUserId = CurUserId
        fetchUsersDataFromCoreData()
        isLoading = false
    }
    
    func createGroupName() -> String{
        return chat.name ?? "dummyname"
    }
    
    func getName(userId: String) -> String{
        return participants.first(where: { $0.id == userId })?.name ?? "Unknown"
    }
    
    func fetchUsersDataFromCoreData(){
        for participant in  chat.participants {
            if participant != CurUserId {
                if let regParticipant = PersistenceController.shared.fetUserById(id: participant){
                    participants.append(chatuser(id: regParticipant.databaseId ?? participant, name: regParticipant.firstName ?? "UnknownFromData"))
                } else {
                    participants.append(chatuser(id: participant, name: "Unknown"))
                }
                
            }
        }
        self.chatName = createGroupName()
    }
    
    func startListeningToMsgs() {
        messageStreamTask?.cancel()
        
        messageStreamTask = Task {
            do {
                for try await msgs in chatService.listenToMessages(chatID: chat.id) {
                    self.messages = msgs
                }
            } catch {
                print("Failed to listen to messages:", error)
            }
        }
    }
    
    func stopListening() {
        messageStreamTask?.cancel()
        messageStreamTask = nil
    }
}

struct chatuser{
    let id: String
    let name: String
}
