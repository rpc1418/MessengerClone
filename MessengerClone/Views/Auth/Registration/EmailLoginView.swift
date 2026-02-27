//
//  EmailLoginView.swift
//  MessengerClone
//
//  Created by rentamac on 2/20/26.
//

import SwiftUI

struct EmailLoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter
    
    @State private var isPressed = false
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
        
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
            
            VStack(spacing: 30) {
                
                // MARK: Header
                VStack(spacing: 10) {
                    Image(systemName: "envelope.circle.fill")
                        .font(.system(size: 70))
                        .foregroundColor(.white)
                    
                    Text("Sign In with Email")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // MARK: Input Fields
                VStack(spacing: 16) {
                    
                    TextField("Email Address", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                    
                    HStack {
                        if isSecure {
                            SecureField("Password", text: $password)
                        } else {
                            TextField("Password", text: $password)
                        }
                        
                        Button {
                            isSecure.toggle()
                        } label: {
                            Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                
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
                    .background(Color.black.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .disabled(email.isEmpty || password.isEmpty || authViewModel.isLoading)
                .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1)
                
                // MARK: Sign Up OPtion
                HStack{
                    Text("Don't have an account?")
                        .font(.default)
                        .underline()
                    
                    Button{
                        router.navigate(to: .emailRegistrationView)
                    } label: {
                        Text("Sign Up !!").font(.default).fontWeight(
                            .bold
                        )
                    }
                    
                }
                
                // MARK: Forgot Password Button
                Button{
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
            }
            .padding(.top, 80)
        }
    }
    
    // MARK: - Login Function
    private func login() {
        Task {
            await authViewModel.loginWithEmail(
                email: email,
                password: password
            )
                
            if(authViewModel.errorMessage != nil){
                if(authViewModel.errorMessage!.elementsEqual("The supplied auth credential is malformed or has expired.")){
                    
                    router.goToHome()
                    router.navigate(to: .emailRegistrationView)
                }
                
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            router.goToHome()
                        }
            }
        }
    }
}

#Preview {
    EmailLoginView()
}
