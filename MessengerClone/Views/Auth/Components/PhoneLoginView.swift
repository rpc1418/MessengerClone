// PhoneLoginView.swift
// MessengerClone

import SwiftUI

struct PhoneLoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var phoneNumber: String = ""
    @State private var countryCode: String = "+91"
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue, .white)
                    .shadow(radius: 10)

                Text("Sign In")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Enter your phone number to continue")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            InputCard(title: "Phone Number *") {
                PhoneInputView(
                    countryCode: $countryCode,
                    phoneNumber: $phoneNumber
                )
            }

            PrimaryButtons(
                title: authViewModel.isLoading ? "Sending OTP..." : "Continue",
                icon: "arrow.right",
                isLoading: authViewModel.isLoading
            ) {
                Task {
                    let fullPhone = countryCode + phoneNumber
                    await authViewModel.sendOTP(phoneNumber: fullPhone)

                    if authViewModel.errorMessage == nil {
                        router.navigate(
                            to: .otpVerification(
                                phone: fullPhone,
                                firstName: "",
                                lastName: "",
                                about: ""
                            )
                        )
                    }
                }
            }
            .disabled(phoneNumber.isEmpty || authViewModel.isLoading)

            SecondaryButtons("Back to Login") {
                router.goBack()
            }

            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Phone Number")
        .navigationBarTitleDisplayMode(.inline)
    }
}

