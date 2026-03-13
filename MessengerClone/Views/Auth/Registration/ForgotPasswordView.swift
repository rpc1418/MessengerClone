//
//  ForgotPasswordView.swift
//  MessengerClone
//
//  Created by rentamac on 2/23/26.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter
    @State private var email = ""
    @State private var showSuccess = false
    @State private var animate = false
    
    var body: some View {
        ZStack {
            
            // MARK: Background
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
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // MARK: Icon + Title
                VStack(spacing: 15) {
                    
                    Image(systemName: "lock.rotation")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .scaleEffect(animate ? 1 : 0.6)
                        .opacity(animate ? 1 : 0)
                    
                    Text("Forgot Password?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Enter your registered email address and we’ll send you a password reset link.")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal)
                }
                
                // MARK: Email Field
                VStack(spacing: 16) {
                    
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .cornerRadius(14)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .offset(y: animate ? 0 : 40)
                .opacity(animate ? 1 : 0)
                
                // MARK: Reset Button
                Button {
                    resetPassword()
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Send Reset Link")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black.opacity(0.85))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .shadow(radius: 5)
                }
                .padding(.horizontal)
                .disabled(email.isEmpty || authViewModel.isLoading)
                .opacity(email.isEmpty ? 0.6 : 1)
                
                // MARK: Success Message
                if showSuccess {
                    Text("Reset link sent successfully ✉️")
                        .foregroundColor(.white)
                        .font(.footnote)
                        .transition(.opacity)
                }
                
                // MARK: Error Message
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.white)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // MARK: Back Button
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
    
    // MARK: Reset Logic
    private func resetPassword() {
        Task {
            await authViewModel.sendPasswordReset(email: email)
                
            if authViewModel.errorMessage == nil {
                withAnimation {
                    showSuccess = true
                }
            }
        }
    }
}
