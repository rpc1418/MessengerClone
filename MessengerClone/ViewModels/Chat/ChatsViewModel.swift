import SwiftUI
import Combine

@MainActor
final class ChatsViewModel: ObservableObject {

    @Published var chats: [Chat] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let chatService: ChatService
    private var listenTask: Task<Void, Never>?

    init(chatService: ChatService = ChatService()) {
        self.chatService = chatService
    }

    // Filtered Chats
    var filteredChats: [Chat] {
        if searchText.isEmpty {
            return chats
        }

        let query = searchText.lowercased()

        return chats.filter { chat in
            (chat.name ?? "")
                .lowercased()
                .contains(query)
            ||
            chat.lastMessage
                .lowercased()
                .contains(query)
        }
    }

    // Firestore Listener
    func startListeningToChats(userID: String) {
        isLoading = true
        listenTask?.cancel()

        listenTask = Task {
            do {
                for try await chats in chatService.listenToUserChats(userID: userID) {
                    self.chats = chats
                    self.isLoading = false
                }
            } catch {
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
