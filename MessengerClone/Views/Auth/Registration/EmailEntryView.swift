//
//  EmailEntryView.swift
//  MessengerClone
//
//  Created by rentamac on 2/23/26.
//
//

import SwiftUI

struct EmailEntryView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter
    
    @State private var email = ""
    @State private var animate = false
    @State private var floating = false
    
    var body: some View {
        ZStack {
            
            // MARK: Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.indigo,
                    Color.purple,
                    Color.pink
                ]),
                startPoint: animate ? .topLeading : .bottomTrailing,
                endPoint: animate ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: animate)
            
            // MARK: Background Glow Effect
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
            
            VStack(spacing: 40) {
                
                Spacer()
                
                // MARK: Floating Icon Section
                VStack(spacing: 18) {
                    
                    Image(systemName: "envelope.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .offset(y: floating ? -8 : 8)
                        .animation(
                            .easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: floating
                        )
                    
                    Text("Continue with Email")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Enter your email address to proceed")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // MARK: Glass Card Container
                VStack(spacing: 22) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("example@email.com", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(14)
                            .foregroundColor(.white)
                    }
                    
                    // MARK: Continue Button
                    Button {
                        checkEmail()
                    } label: {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Continue")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [Color.white, Color.white.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.purple)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.3), radius: 10)
                    }
                    .disabled(email.isEmpty || authViewModel.isLoading)
                    .opacity(email.isEmpty ? 0.6 : 1)
                    
                    // MARK: Error
                    if let error = authViewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.white)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                    }
                }
                .padding(28)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .shadow(radius: 25)
                .padding(.horizontal)
                .scaleEffect(animate ? 1 : 0.9)
                .opacity(animate ? 1 : 0)
                
                Spacer()
                
                Text("Secure Authentication Powered by Firebase")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 25)
            }
            .padding()
        }
        .onAppear {
            animate = true
            floating = true
        }
    }
    
    // MARK: Logic (UNCHANGED)
    private func checkEmail() {
        Task {
            let exists = await authViewModel.checkEmailAndRoute(email: email)
            
            if authViewModel.errorMessage == nil {
                if exists {
                    router.navigate(to: .passwordVerification(email: email))
                }
                else {
                    router.navigate(to: .emailRegistrationView)
                }
            }
        }
    }
}
