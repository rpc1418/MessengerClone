//
//  ContentView.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        NavigationStack(path: $router.path) {
//            HomeView() // Landing screen
            Text("Hello World!")
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
        
    }
}

#Preview {
    ContentView().environmentObject(AppRouter())
}
