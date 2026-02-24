//
//  RootView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.


import SwiftUI
import FirebaseAuth

struct RootView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        Group {

            // Not logged in
            if authViewModel.currentUser == nil {
                LoginView()
//                    .environmentObject(authViewModel)
            }

            // Logged in, checking Firestore
//            else if authViewModel.userExists == nil {
//                ProgressView("Loading...")
//            }
//
//            // Logged in, profile exists
//            else if authViewModel.userExists == true {
//                HomeView()
//
//            }
            else {
//                RegistrationView()
                HomeView()
            }
                
        }
        .onAppear {
            print("RootView: currentUser = \(authViewModel.currentUser?.uid ?? nil)")
            print("RootView: userExists = \(authViewModel.userExists ?? nil)")
        }
    }
}


//import SwiftUI
//import FirebaseAuth
//
//struct RootView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @EnvironmentObject var appRouter: AppRouter
//
//    var body: some View {
//        Group {
//            if authViewModel.currentUser == nil {
//                LoginView()
//            }
//            else {
//                HomeView()
//            }
//        }
//        .onAppear {
//            print("RootView: currentUser = \(authViewModel.currentUser?.uid ?? nil)")
//            print("RootView: userExists = \(authViewModel.userExists ?? nil)")
//        }
//    }
//}
