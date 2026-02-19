//
//  ChatViewModel.swift
//  MessengerClone
//
//  Created by rentamac on 2/17/26.
//

import Contacts
import Combine
import FirebaseFirestore
import CoreData

class ChatViewModel: ObservableObject {
    let chat: Chat
    let CurUserId: String
    @Published var messages: [Message] = []
    private var processedMessageIDs: Set<String> = []

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
        if(chat.isGroup){
            return chat.name ?? "dummyname"
        }else{
            var name = ""
            participants.forEach({ (user) in
                if user.id != CurUserId{
                    name.append(user.name)
                }
            })
            return name
        }
        
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
    
    func markMessagesRead(allowed: Bool) {
        
       
        
        for message in messages {
            
            // Skip if already processed
            if processedMessageIDs.contains(message.id) { continue }
            
            // Skip your own messages
            if message.senderID == CurUserId { continue }
            
            // If not already read
            if !message.readBy.contains(CurUserId) {
                if allowed{
                    chatService.markMessageAsRead(
                        chatID: chat.id,
                        messageID: message.id,
                        userID: CurUserId
                    )
                }
                
            }
            
            // Mark as processed so we don't check again
            processedMessageIDs.insert(message.id)
        }
    }

    
    

}

struct chatuser{
    let id: String
    let name: String
}
