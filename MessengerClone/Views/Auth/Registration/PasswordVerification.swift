//
//  PasswordVerification.swift
//  MessengerClone
//
//  Created by rentamac on 2/23/26.
//

import SwiftUI

struct PasswordVerification: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter
    
    let email: String
    
    @State private var password = ""
    @State private var isSecure = true
    @State private var animate = false
    
    var body: some View {
        ZStack {
            
            // MARK: Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue,
                    Color.purple,
                    Color.pink
                ]),
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)

                Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 250)
                .blur(radius: 80)
                .offset(x: -120, y: -200)

                Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 300)
                .blur(radius: 100)
                .offset(x: 150, y: 250)
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // MARK: Header
                VStack(spacing: 12) {
                    
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 65))
                        .foregroundColor(.white)
                        .scaleEffect(animate ? 1 : 0.6)
                        .opacity(animate ? 1 : 0)
                    
                    Text("Welcome Back")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(email)
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                // MARK: Password Field
                HStack {
                    if isSecure {
                        SecureField("Enter Password", text: $password)
                    } else {
                        TextField("Enter Password", text: $password)
                    }
                    
                    Button {
                        isSecure.toggle()
                    } label: {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.95))
                .cornerRadius(16)
                .shadow(radius: 8)
                .padding(.horizontal)
                .offset(y: animate ? 0 : 40)
                .opacity(animate ? 1 : 0)
                
                // MARK: Login Button
                Button {
                    login()
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .shadow(radius: 8)
                }
                .padding(.horizontal)
                .disabled(password.isEmpty || authViewModel.isLoading)
                .opacity(password.isEmpty ? 0.6 : 1)
                
                // MARK: Forgot Password
                Button {
                    router.navigate(to: .forgotPasswordView)
                } label: {
                    Text("Forgot Password ??").font(.default).fontWeight(.semibold).foregroundStyle(Color.white).opacity(0.7)
                }
                
                // MARK: Error
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // MARK: Back
                Button {
                    router.goBack()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back to Login").fontWeight(.bold).font(.headline)
                    }
                    
                }
                .foregroundColor(.white.opacity(0.9))
                .padding(.bottom, 30)
                .padding()
            }
            .padding()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animate = true
            }
        }
    }
    
    // MARK: Login Logic
    private func login() {
        Task {
            await authViewModel.loginWithEmail(email: email, password: password)
            
            if authViewModel.errorMessage == nil {
                router.goToHome()
                router.navigate(to: .home)
            }
        }
    }
}
