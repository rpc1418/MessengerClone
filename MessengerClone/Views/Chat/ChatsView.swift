import SwiftUI
import FirebaseFirestore

struct ChatsView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ChatsViewModel()

    var body: some View {
        VStack(spacing: 0) {

            searchBar
            
            storiesSection

            List(viewModel.chats) { chat in
                ChatRowView(chat: chat)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            guard let user = authViewModel.appUser else { return }
            viewModel.startListeningToChats(userID: user.uid)
        }
        .onDisappear {
            viewModel.stopListening()
        }
    }
}

private extension ChatsView {

    var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            Text("Search")
                .foregroundColor(.gray)

            Spacer()
        }
        .padding(.horizontal, 12)
        .frame(height: 36) // 🔥 smaller height (Messenger uses smaller than 44)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray5))
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 6)
    }
}


private extension ChatsView {

    var storiesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {

                storyItem(name: "Your story", isAdd: true)

                storyItem(name: "Joshua", isOnline: true)
                storyItem(name: "Martin", isOnline: true)
                storyItem(name: "Karen", isOnline: true)
                storyItem(name: "Martha")
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }

    func storyItem(name: String,
                   isAdd: Bool = false,
                   isOnline: Bool = false) -> some View {

        VStack(spacing: 6) {

            ZStack(alignment: .bottomTrailing) {

                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 64, height: 64)

                if isAdd {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        )
                }

                if isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 2)
                        )
                }
            }

            Text(name)
                .font(.system(size: 12))
                .lineLimit(1)
        }
    }
}
//private extension ChatsView {
//
//    var chatList: some View {
//        List(dummyChats) { chat in
//            ChatRowView(chat: chat)
//        }
//        .listStyle(.plain)
//    }
//
//    var dummyChats: [Chat] {
//        [
//            Chat(
//                id: "1",
//                participants: [],
//                isGroup: false,
//                name: "Martin Randolph",
//                lastMessage: "You: What's man!",
//                lastUpdated: Timestamp(date: Date())
//            ),
//            Chat(
//                id: "2",
//                participants: [],
//                isGroup: false,
//                name: "Andrew Parker",
//                lastMessage: "You: Ok, thanks!",
//                lastUpdated: Timestamp(date: Date().addingTimeInterval(-1800))
//            ),
//            Chat(
//                id: "3",
//                participants: [],
//                isGroup: false,
//                name: "Karen Castillo",
//                lastMessage: "You: Ok, See you in Tokyo",
//                lastUpdated: Timestamp(date: Date().addingTimeInterval(-3600))
//            ),
//            Chat(
//                id: "4",
//                participants: [],
//                isGroup: false,
//                name: "Karen Castillo",
//                lastMessage: "You: Ok, See you in Tokyo",
//                lastUpdated: Timestamp(date: Date().addingTimeInterval(-3600))
//            )
//        ]
//    }
//}
