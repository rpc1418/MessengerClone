//
//  EmailRegistrationView.swift
//  MessengerClone
//
//  Created by rentamac on 2/21/26.
//
//

import SwiftUI

struct EmailRegistrationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var about = ""
    @State private var countryCode = "+91"
    @State private var phoneNumber = ""
    @State private var email = ""
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
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    
                    // MARK: Header
                    VStack(spacing: 12) {
                        
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                            .scaleEffect(animate ? 1 : 0.6)
                            .opacity(animate ? 1 : 0)
                        
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Register with your email and build your profile")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // MARK: Details Container
                    VStack(spacing: 22) {
                        
                        ProfileAvatarView()
                        
                        // MARK: Email Section
                        VStack(spacing: 16) {
                            
                            TextField("Email Address", text: $email)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .padding()
                                .background(Color.white)
                                .cornerRadius(14)
                            
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
                            .background(Color.white)
                            .cornerRadius(14)
                        }
                        
                        Divider().padding(.vertical, 5)
                        
                        // MARK: Profile Fields
                        InputCard(title: "First Name *") {
                            AppTextField(
                                placeholder: "Enter first name",
                                text: $firstName
                            )
                        }
                        
                        InputCard(title: "Last Name") {
                            AppTextField(
                                placeholder: "Enter last name",
                                text: $lastName
                            )
                        }
                        
                        InputCard(title: "About") {
                            AppTextField(
                                placeholder: "A short bio",
                                text: $about
                            )
                        }
                        
                        InputCard(title: "Phone Number *") {
                            PhoneInputView(
                                countryCode: $countryCode,
                                phoneNumber: $phoneNumber
                            )
                        }
                        
                        // MARK: Register Button
                        Button {
                            register()
                        } label: {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Create Account")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [Color.blue, Color.purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 8)
                        }
                        .disabled(firstName.isEmpty || phoneNumber.isEmpty || authViewModel.isLoading)
                        .opacity(firstName.isEmpty || phoneNumber.isEmpty ? 0.6 : 1)
                        .padding(.top, 8)
                        
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(25)
                    .background(.ultraThinMaterial)
                    .cornerRadius(30)
                    .shadow(radius: 20)
                    .padding(.horizontal)
                    .offset(y: animate ? 0 : 40)
                    .opacity(animate ? 1 : 0)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animate = true
            }
        }
    }
    
    private func register() {
        Task {
            let fullPhoneNumber = countryCode + phoneNumber
            
            await authViewModel.registerWithEmail(
                email: email,
                password: password,
                phoneNumber: fullPhoneNumber,
                firstName: firstName,
                lastName: lastName.isEmpty ? "" : lastName,
                about: about.isEmpty ? "" : about
            )
            
            if authViewModel.errorMessage == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    router.goToHome()
                }
            } else {
                router.goBack()
            }
        }
    }
}
