import SwiftUI
import FirebaseFirestore

struct ChatsView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appRouter: AppRouter
    @StateObject private var viewModel = ChatsViewModel()
    @EnvironmentObject var contactViewModel: ContactsViewModel

    var body: some View {
        VStack(spacing: 0) {

            searchBar

            //Hide stories while searching
            if viewModel.searchText.isEmpty {
                storiesSection
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            List(viewModel.filteredChats) { chat in
                if let currentUserID = authViewModel.appUser?.uid {
                    ChatRowView(chat: chat, CurUserId: currentUserID)
                        .onTapGesture {
                            appRouter.navigate(to: .chat(chat: chat))
                        }
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.searchText)

        // 🔥 Modern lifecycle listener
        .task(id: authViewModel.appUser?.uid) {
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

            TextField("Search", text: $viewModel.searchText)
                .textFieldStyle(.plain)

            if !viewModel.searchText.isEmpty {
                Button {
                    viewModel.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 36)
        .background(
            RoundedRectangle(cornerRadius: 10)
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
            HStack(spacing: 18) {
                
                storyItem(name: "Your story", isAdd: true)
                ForEach(contactViewModel.filteredContacts(type: 0 ),id: \.objectID){
                    contact in storyItem(name: contact.fullName ,isAdd: false, isOnline: true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    
    func storyItem(
        name: String,
        isAdd: Bool = false,
        isOnline: Bool = false
    ) -> some View {
        
        VStack(spacing: 6) {
            
            ZStack(alignment: .bottomTrailing) {
                
                // Only show avatar if NOT Your Story
                if !isAdd {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 52, height: 52)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                }
                
                // Only show plus for Your Story
                if isAdd {
                    ZStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 52, height: 52)
                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.primary)
                    }
                }
                
                // Online indicator only for real users
                if isOnline && !isAdd {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2.5)
                        )
                        .offset(x: -3.5, y: -3.5)
                }
            }
            .frame(width: 52, height: 52)
            
            Text(name)
                .font(.system(size: 13))
                .foregroundColor(.textSecondary)
                .lineLimit(1)
                .frame(width: 62)
                .multilineTextAlignment(.center)
        }
    }
}
