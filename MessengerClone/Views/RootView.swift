//
//  RootView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appRouter: AppRouter

    @State private var selectedTab: AppTab = .chats

    var body: some View {

        // 🔹 NOT logged in
        if authViewModel.currentUser == nil {
            LoginView()
        }

        // 🔹 Logged in, checking Firestore
        else if authViewModel.userExists == nil {
            ProgressView("Loading...")
        }

        // 🔹 Logged in & profile exists → MAIN APP
        else if authViewModel.userExists == true {

            NavigationStack(path: $appRouter.path) {

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
            // ✅ STATIC bottom tab bar (never moves)
            .safeAreaInset(edge: .bottom) {
                HomeBottomTabView(selectedTab: $selectedTab)
            }
        }

        // 🔹 Logged in, profile missing
        else {
            RegistrationView()
        }
    }
}

//#Preview {
//    let authVM = AuthViewModel()
//    let router = AppRouter()
//
//    // 🔹 Mock logged-in state
//    authVM.currentUser = AppUser.preview
//    authVM.userExists = true
//
//    RootView()
//        .environmentObject(authVM)
//        .environmentObject(router)
//}
//
