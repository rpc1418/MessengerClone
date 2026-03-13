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
    @StateObject private var themeManager = ThemeManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(router)
                .environmentObject(authViewModel)
                .environmentObject(contactsViewModel)
                .environmentObject(themeManager)   // INJECT
                .preferredColorScheme(themeManager.colorScheme) //  APPLY
        }
        
    }
}
