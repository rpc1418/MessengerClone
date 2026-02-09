import SwiftUI

struct ContentView: View {

    @EnvironmentObject var router: AppRouter
    @State private var selectedTab: AppTab = .chats

    var body: some View {
        ZStack(alignment: .bottom) {

            // 🔹 Navigation content (changes)
            NavigationStack(path: $router.path) {
                Group {
                    switch selectedTab {
                    case .chats:
                        HomeView()
                    case .people:
                        PeopleView()
                    case .discover:
                        DiscoverView()
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .NewChatViewNav:
                        PeopleView()
                    case .developerView:
                        Text("Developer View")
                    }
                }
            }

            // 🔹 Fixed Bottom Tab Bar (STATIC)
            HomeBottomTabView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppRouter())
}
