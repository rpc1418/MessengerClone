////
////  RegistrationView.swift
////  MessengerClone
////
////  Created by rentamac on 2/5/26.
////
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var about = ""
    @State private var countryCode = "+91"
    @State private var phoneNumber = ""
    @State private var animate = false

    var body: some View {
        ZStack {
            
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
                    VStack(spacing: 12) {
                        
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 70))
                            .foregroundColor(.white)
                            .scaleEffect(animate ? 1 : 0.6)
                            .opacity(animate ? 1 : 0)
                        
                        Text("Create Your Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("This is how your friends will see you")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                    
                    // MARK: Details Container
                    VStack(spacing: 22) {
                        
                        ProfileAvatarView()
                        
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

                        // MARK: Continue Button
                        PrimaryButton(
                            title: authViewModel.isLoading ? "Sending OTP..." : "Continue"
                        ) {
                            let fullPhoneNumber = countryCode + phoneNumber
                            print("Continue tapped")
                            print("Phone:", fullPhoneNumber)

                            Task {
                                await authViewModel.sendOTP(phoneNumber: fullPhoneNumber)

                                if authViewModel.errorMessage == nil {
                                    router.navigate(
                                        to: .otpVerification(
                                            phone: fullPhoneNumber,
                                            firstName: firstName,
                                            lastName: lastName.isEmpty ? nil : lastName,
                                            about: about.isEmpty ? nil : about
                                        )
                                    )
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
}
