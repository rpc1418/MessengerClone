//
//  HomeView.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var appRouter: AppRouter
    var body: some View {
        Text("Hello, World!")
        Text("HomeView")
        Button("Sign Out!!!"){
            authViewModel.signOut()
        }
        Button("Go To Chat"){
            appRouter.navigate(to: .NewChatViewNav)
        }
    }
}
