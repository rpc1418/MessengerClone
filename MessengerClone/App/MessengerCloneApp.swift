//
//  MessengerCloneApp.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.
//

import SwiftUI

@main
struct MessengerCloneApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var router: AppRouter = AppRouter()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var contactsViewModel = ContactsViewModel()
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(authViewModel)
                .environmentObject(contactsViewModel)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                print("App is active")
            case .background:
                print("App is in background")
            case .inactive:
                print("App is inactive")

            @unknown default:
                break
            }
        }
    }
}
