//
//  ChatService.swift
//  FirebaseAuthPrac
//
//  Created by rentamac on 07/02/2026.
//

import FirebaseFirestore
final class ChatService {
    
    let db = Firestore.firestore()
    
    
    func createChat(
            participants: [String],
            isGroup: Bool,
            name: String? = nil
        ) async throws -> String {
            var chatData: [String: Any] = [
                "participants": participants,
                "isGroup": isGroup,
                "lastMessage": "",
                "lastUpdated": Timestamp(date: Date()),
                "lastRead": Dictionary(
                    uniqueKeysWithValues: participants.map { ($0, Timestamp(date: Date())) }
                ),
                "name": name ?? ""
            ]
            
            
            
            let chatRef = db.collection("chats").document()
            try await chatRef.setData(chatData)
            
            print("Chat created successfully: \(chatRef.documentID)")
            return chatRef.documentID
        }
        
        
        func sendMessage(
            chatID: String,
            senderID: String,
            text: String
        ) async throws {
            let messageData: [String: Any] = [
                "senderID": senderID,
                "text": text,
                "timestamp": Timestamp(date: Date()),
                "readBy": [senderID]
            ]
            
            let chatRef = db.collection("chats").document(chatID)
            let messageRef = chatRef.collection("messages").document()
            
            try await withThrowingTaskGroup(of: Void.self) { group in
                
                group.addTask {
                    try await messageRef.setData(messageData)
                }
                
                
                group.addTask {
                    try await chatRef.updateData([
                        "lastMessage": text,
                        "lastUpdated": Timestamp(date: Date()),
                        "lastRead.\(senderID)": Timestamp(date: Date())
                    ])
                }
                
                try await group.waitForAll()
            }
        }
    func uploadAndSendImage(chatId: String , senderId: String , data: Data) async {
        do {
            // Compress image (optional but recommended)
            guard let uiImage = UIImage(data: data),
                  let compressedData = uiImage.jpegData(compressionQuality: 0.6)
            else { return }
            
            let imageName = "IMG_\(UUID().uuidString).jpg"
            
            
            // Upload to Firebase Storage
            
            
            
            try await sendMessage(chatID: chatId, senderID: senderId, text: "[image]\(imageName)")
            
        } catch {
            print("Image upload failed:", error.localizedDescription)
        }
    }
    
    

    func uploadAndSendDocument(
        chatId: String,
        senderId: String,
        fileURL: URL
    ) async {
        
        do {
            let fileName = "FILE_\(UUID().uuidString)_\(fileURL.lastPathComponent)"
            
            // Reuse existing sendMessage
            try await sendMessage(
                chatID: chatId,
                senderID: senderId,
                text: "[file]\(fileName)"
            )
            
        } catch {
            print("Document upload failed:", error.localizedDescription)
        }
    }
    func listenToUserChats(userID: String) -> AsyncThrowingStream<[Chat], Error> {
            AsyncThrowingStream { continuation in
                let query = db.collection("chats")
                    .whereField("participants", arrayContains: userID)
                    .order(by: "lastUpdated", descending: true)
                
                let listener = query.addSnapshotListener { snapshot, error in
                    if let error {
                        continuation.finish(throwing: error)
                        return
                    }
                    
                    let chats = snapshot?.documents.compactMap { doc -> Chat? in
                        let data = doc.data()
                        return Chat(
                            id: doc.documentID,
                            participants: data["participants"] as? [String] ?? [],
                            isGroup: data["isGroup"] as? Bool ?? false,
                            name: data["name"] as? String,
                            lastMessage: data["lastMessage"] as? String ?? "",
                            lastUpdated: data["lastUpdated"] as? Timestamp ?? Timestamp()
                        )
                    } ?? []
                    
                    continuation.yield(chats)
                }
                
                continuation.onTermination = { _ in
                    listener.remove()
                }
            }
        }



    func listenToMessages(chatID: String) -> AsyncThrowingStream<[Message], Error> {

        return AsyncThrowingStream { continuation in
            let listener = db.collection("chats")
                .document(chatID)
                .collection("messages")
                .order(by: "timestamp", descending: false)
                .addSnapshotListener { snapshot, error in
                    if let error {
                        continuation.finish(throwing: error)
                        return
                    }

                    let messages = snapshot?.documents.compactMap { doc -> Message in
                        let data = doc.data()
                        return Message(
                            id: doc.documentID,
                            senderID: data["senderID"] as? String ?? "",
                            text: data["text"] as? String ?? "",
                            timestamp: data["timestamp"] as? Timestamp ?? Timestamp(),
                            readBy: data["readBy"] as? [String] ?? []
                        )
                    } ?? []

                    continuation.yield(messages)
                }

            continuation.onTermination = { _ in
                listener.remove()
            }
        }
    }
    
    func fetchChat(by chatID: String) async throws -> Chat? {
            let doc = try await db.collection("chats")
                .document(chatID)
                .getDocument()
            
            guard let data = doc.data() else {
                return nil
            }
            
            return Chat(
                id: doc.documentID,
                participants: data["participants"] as? [String] ?? [],
                isGroup: data["isGroup"] as? Bool ?? false,
                name: data["name"] as? String,
                lastMessage: data["lastMessage"] as? String ?? "",
                lastUpdated: data["lastUpdated"] as? Timestamp ?? Timestamp()
            )
        }
    
    func fetchChatsForUser(userID: String) async throws -> [Chat] {
        
        let snapshot = try await db.collection("chats")
            .whereField("participants", arrayContains: userID)
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            
            return Chat(
                id: doc.documentID,
                participants: data["participants"] as? [String] ?? [],
                isGroup: data["isGroup"] as? Bool ?? false,
                name: data["name"] as? String,
                lastMessage: data["lastMessage"] as? String ?? "",
                lastUpdated: data["lastUpdated"] as? Timestamp ?? Timestamp()
            )
        }
    }
    
    func markMessageAsRead(chatID: String,
                           messageID: String,
                           userID: String) {
        
        
        
        db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)
            .updateData([
                "readBy": FieldValue.arrayUnion([userID])
            ])
    }


}
