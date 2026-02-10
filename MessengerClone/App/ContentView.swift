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
            RootView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .login:
                        LoginView()
                    case .phoneLogin:
                        PhoneLoginView()
                    case let .otpVerification(phone, firstName, lastName, about):
                        OTPVerificationView(
                            firstName: firstName ?? "",
                            lastName: lastName ?? "",
                            about: about ?? "",
                            phoneNumber: phone
                        )
                    case .registration:
                        RegistrationView()
                    case .home:
                        RootView()
                    case .newChat:
                        PeopleView()
                    case .developerView:
                        Text("Hello World!")
                    }
                }
        }
        .overlay(alignment: .bottom) {
            Text("Stack count: \(router.path.count)")
                .font(.caption)
                .padding(4)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppRouter())
        .environmentObject(AuthViewModel())
}
