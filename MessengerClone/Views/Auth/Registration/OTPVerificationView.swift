//
//  OTPVerificationView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//
//
//

import SwiftUI

struct OTPVerificationView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var viewModel: AuthViewModel

    let firstName: String
    let lastName: String
    let about: String
    let phoneNumber: String

    @State private var otp = ""
    @State private var resendTimer = 30
    @State private var timer: Timer?
    
    @State private var animate = false
    @State private var floating = false

    @Environment(\.dismiss) private var dismiss

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
                .frame(width: 280)
                .blur(radius: 80)
                .offset(x: -150, y: -250)
            
            Circle()
                .fill(Color.pink.opacity(0.15))
                .frame(width: 300)
                .blur(radius: 100)
                .offset(x: 150, y: 250)
            
            VStack(spacing: 35) {
                
                Spacer()
                
                // MARK: Floating Icon
                VStack(spacing: 16) {
                    
                    Image(systemName: "number.circle.fill")
                        .font(.system(size: 85))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .offset(y: floating ? -8 : 8)
                        .animation(
                            .easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: floating
                        )
                    
                    Text("Verify OTP")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Code sent to\n\(phoneNumber)")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
                
                VStack(spacing: 22) {
                    // MARK: OTP input
                    OTPInputView(otp: $otp)
                    
                    PrimaryButton(
                        title: viewModel.isLoading ? "Verifying..." : "Verify & Continue"
                    ) {
                        Task {
                            await viewModel.verifyOTP(otp)

                            if viewModel.errorMessage == nil {
                                if !firstName.isEmpty {
                                    try? await FirestoreService.shared.saveUserProfile(
                                        firstName: firstName,
                                        lastName: lastName.isEmpty ? nil : lastName,
                                        about: about.isEmpty ? nil : about,
                                        phoneNumber: phoneNumber,
                                        isNewUser: true
                                    )
                                    await viewModel.checkPhoneExists(phoneNumber)
                                }

                                router.goToHome()
                            }
                        }
                    }
                    .disabled(otp.count < 6 || viewModel.isLoading)
                    .opacity(otp.count == 6 && !viewModel.isLoading ? 1 : 0.5)
                    
                    resendSection
                    
                    if let error = viewModel.errorMessage {
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
                
                Text("Secure OTP Verification")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.75))
                    .padding(.bottom, 25)
            }
            .padding()
        }
        .onAppear {
            animate = true
            floating = true
            startResendTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - Resend
    private var resendSection: some View {
        VStack(spacing: 6) {
            if resendTimer > 0 {
                Text("Resend OTP in \(resendTimer)s")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.9))
            } else {
                Button("Resend OTP") { resendOTP() }
                    .font(.footnote)
                    .foregroundColor(.white)
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
