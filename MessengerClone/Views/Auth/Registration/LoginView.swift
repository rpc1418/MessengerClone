//
//  LoginView.swift
//  MessengerClone
//
//  Created by rentamac on 2/7/26.
//


import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var phoneNumber = ""
    @State private var countryCode = "+91"

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.8),
                    Color.purple.opacity(0.7),
                    Color.pink.opacity(0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    Image(systemName: "message.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                    Text("Messenger")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 2)

                    Text("Connect with your friends")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 20) {
                    
                    PrimaryButtons(
                        title: "Sign In with Email",
                        icon: "envelope.fill",
                        isLoading: authViewModel.isLoading
                    ) {
                        router.navigate(to: .emailLogin)
                    }
                        
                    PrimaryButtons(
                        title: "Sign In with Phone",
                        icon: "phone.fill",
                        isLoading: authViewModel.isLoading
                    ) {
                        // You can also store phone data in view model if needed
                        router.navigate(to: .phoneLogin)
                    }

                    SecondaryButtons("Create New Account") {
                        router.navigate(to: .registration)
                    }
                }
                .padding(.horizontal)

                Spacer()

                Text("Secure & Fast")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
            .padding()
        }
    }
}


