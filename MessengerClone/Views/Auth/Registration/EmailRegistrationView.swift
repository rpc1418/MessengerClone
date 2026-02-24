//
//  EmailRegistrationView.swift
//  MessengerClone
//
//  Created by rentamac on 2/21/26.
//

import SwiftUI
import FirebaseAuth

struct EmailRegistrationView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var about = ""
    @State private var countryCode = "+91"
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // MARK: - Header
                Text("You don't have account!! Create your profile")
                    .font(.title)
                    .fontWeight(.bold)

                Text("This is how your friends will see you")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                ProfileAvatarView()
                
                // MARK: Email Fields
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
                        placeholder: "A short bio (optional)",
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
                PrimaryButton(
                    title: authViewModel.isLoading ? "Registering..." : "Continue"
                ) {
                    let fullPhoneNumber = countryCode + phoneNumber
                    print("Continue tapped")
                    print("Phone:", fullPhoneNumber)

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
//                            router.navigate(to: .home)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                        router.goToHome()
                                    }
//                            return
                        }
                        else{
//                            router.goToHome()
                            router.goBack()
                        }
                    }
                }
                .disabled(
                    firstName.isEmpty ||
                    phoneNumber.isEmpty ||
                    authViewModel.isLoading
                )
                .opacity(
                    firstName.isEmpty ||
                    phoneNumber.isEmpty ||
                    authViewModel.isLoading
                        ? 0.5
                        : 1
                )
                .padding(.top, 10)

                if let error = authViewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    EmailRegistrationView()
}
