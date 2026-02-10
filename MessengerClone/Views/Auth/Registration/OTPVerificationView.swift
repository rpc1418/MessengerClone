//
//  OTPVerificationView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//
//

import SwiftUI

struct OTPVerificationView: View {

    @ObservedObject var viewModel: AuthViewModel

    let firstName: String
    let lastName: String
    let about: String
    let phoneNumber: String

    @State private var otp = ""
    @State private var resendTimer = 30
    @State private var timer: Timer?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            VStack(spacing: 8) {
                Text("Verify OTP")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Code sent to \(phoneNumber)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            OTPInputView(otp: $otp)

//            PrimaryButton(
//                title: viewModel.isLoading ? "Verifying..." : "Verify & Continue"
//            ) {
//                Task {
//                    // 1️⃣ Verify OTP (login)
//                    await viewModel.verifyOTP(otp)
//
//                    // 2️⃣ If registering, save profile
//                    if !firstName.isEmpty {
//                        try? await FirestoreService.shared.saveUserProfile(
//                            firstName: firstName,
//                            lastName: lastName.isEmpty ? nil : lastName,
//                            about: about.isEmpty ? nil : about,
//                            phoneNumber: phoneNumber,
//                            isNewUser: true
//                        )
//                    }
//                }
//            }
            PrimaryButton(
                title: viewModel.isLoading ? "Verifying..." : "Verify & Continue"
            ) {
                Task {
                    // 1️⃣ Verify OTP (Firebase Auth login)
                    await viewModel.verifyOTP(otp)

                    // 2️⃣ If registering, save profile
                    if !firstName.isEmpty {
                        try? await FirestoreService.shared.saveUserProfile(
                            firstName: firstName,
                            lastName: lastName.isEmpty ? nil : lastName,
                            about: about.isEmpty ? nil : about,
                            phoneNumber: phoneNumber,
                            isNewUser: true
                        )

                        // 🔥 THIS WAS MISSING
                        await viewModel.checkPhoneExists(phoneNumber)
                    }
                }
            }

            .disabled(otp.count < 6 || viewModel.isLoading)
            .opacity(otp.count == 6 && !viewModel.isLoading ? 1 : 0.5)

            resendSection

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear { startResendTimer() }
        .onDisappear { timer?.invalidate() }
    }

    // MARK: - Resend

    private var resendSection: some View {
        VStack(spacing: 6) {
            if resendTimer > 0 {
                Text("Resend OTP in \(resendTimer)s")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                Button("Resend OTP") { resendOTP() }
                    .font(.footnote)
            }
        }
    }

    private func startResendTimer() {
        resendTimer = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if resendTimer > 0 {
                resendTimer -= 1
            } else {
                timer?.invalidate()
            }
        }
    }

    private func resendOTP() {
        otp = ""
        viewModel.errorMessage = nil
        Task {
            await viewModel.sendOTP(phoneNumber: phoneNumber)
            startResendTimer()
        }
    }
}
