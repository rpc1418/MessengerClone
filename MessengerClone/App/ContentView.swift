import SwiftUI

struct ContentView: View {

    @EnvironmentObject var router: AppRouter
    @State private var selectedTab: AppTab = .chats

    var body: some View {
        NavigationStack(path: $router.path) {
//            HomeView() // Landing screen
//            Text("Hello World!")
            RootView()
                .navigationDestination(for: Route.self) {
                    route in
                    Group {
                        switch route {
                        case .NewChatViewNav: PeopleView()
                        case .developerView: Text("Hello World!")
                        }
                    }
                }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppRouter())
}
