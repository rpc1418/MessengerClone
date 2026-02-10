//
//  RootView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var authViewModel: AuthViewModel

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
                Home()
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
