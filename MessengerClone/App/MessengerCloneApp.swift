//
//  MessengerCloneApp.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.
//

import SwiftUI

@main
struct MessengerCloneApp: App {
    @StateObject var router: AppRouter = AppRouter()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(router)
        }
    }
}
