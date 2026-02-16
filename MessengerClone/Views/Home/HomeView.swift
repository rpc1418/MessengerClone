import SwiftUI

struct HomeView: View {

    @EnvironmentObject var appRouter: AppRouter
    @State private var selectedTab: AppTab = .chats

    var body: some View {

        VStack(spacing: 0) {

            // STATIC TOP BAR
            HomeTopBarView(
                selectedTab: selectedTab,
                onProfileTap: handleProfileTap
            )

            // DYNAMIC CONTENT
            currentScreen
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
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

        case .people:
            PeopleView()

        case .discover:
            DiscoverView()
        }
    }

    func handleProfileTap() {
        appRouter.navigate(to: .profileView)
    }
}


