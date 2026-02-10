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

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // MARK: - Header
                Text("Create your profile")
                    .font(.title)
                    .fontWeight(.bold)

                Text("This is how your friends will see you")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

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

                PrimaryButton(
                    title: authViewModel.isLoading ? "Sending OTP..." : "Continue"
                ) {
                    let fullPhoneNumber = countryCode + phoneNumber
                    print("Continue tapped")
                    print("Phone:", fullPhoneNumber)

                    Task {
                        await authViewModel.sendOTP(phoneNumber: fullPhoneNumber)

                        if authViewModel.errorMessage == nil {
                            // Route to OTP with profile + phone data
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
            .padding()
        }
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        )
    }
}
