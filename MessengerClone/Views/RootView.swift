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
        Group {

            // Not logged in
            if authViewModel.currentUser == nil {
                LoginView()
//                    .environmentObject(authViewModel)
            }

            // Logged in, checking Firestore
            else if authViewModel.userExists == nil {
                ProgressView("Loading...")
            }

            // Logged in, profile exists
            else if authViewModel.userExists == true {
//                ContentView()
//                Home()
                Text("HomeView")
                                Button("Sign Out!!!"){
                                    authViewModel.signOut()
                                }
                Button("Create new Chat!!!"){
                    appRouter.navigate(to: .newChat)
                }
                Button("View Profile!!!"){
                    appRouter.navigate(to: .profileView)
                }
//                    .environmentObject(authViewModel)
            }

            // Logged in, profile missing
            else {
                RegistrationView()
//                    .environmentObject(authViewModel)
            }
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
