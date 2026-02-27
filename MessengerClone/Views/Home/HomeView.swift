import SwiftUI

struct HomeView: View {

    @EnvironmentObject var appRouter: AppRouter
    @State private var selectedTab: AppTab = .chats
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {

        VStack(spacing: 0) {

            // STATIC TOP BAR
            HomeTopBarView(
                selectedTab: selectedTab,
            )

            // DYNAMIC CONTENT
            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .safeAreaInset(edge: .bottom) {
            HomeBottomTabView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}


private extension HomeView {

    @ViewBuilder
    var currentScreen: some View {
        switch selectedTab {
        case .chats:
            ChatsView()
//            Button("Sign out"){
//                authViewModel.signOut()
//            }

        case .people:
            RegPeopleView()

        case .discover:
            DiscoverView()
            
        case .profile:
            ProfileView()
        }
        
        
    }

    func handleProfileTap() {
        appRouter.navigate(to: .profileView)
    }
}


