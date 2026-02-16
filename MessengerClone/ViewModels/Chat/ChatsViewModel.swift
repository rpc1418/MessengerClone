import SwiftUI
import Combine
import FirebaseFirestore

@MainActor
final class ChatsViewModel: ObservableObject {

    @Published var chats: [Chat] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let chatService: ChatService
    private var listenTask: Task<Void, Never>?

    init(chatService: ChatService = ChatService()) {
        self.chatService = chatService
    }

    func startListening(userID: String) {
        print("🔥 Starting listener for userID:", userID)

        isLoading = true
        listenTask?.cancel()

        listenTask = Task {
            do {
                for try await chats in chatService.listenToUserChats(userID: userID) {
                    print("🔥 Received chats count:", chats.count)
                    self.chats = chats
                    self.isLoading = false
                }
            } catch {
                print("❌ Listener error:", error)
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func stopListening() {
        listenTask?.cancel()
        listenTask = nil
    }
}
