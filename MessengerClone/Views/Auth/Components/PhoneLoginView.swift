
import SwiftUI

struct PhoneLoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

    @State private var phoneNumber: String = ""
    @State private var countryCode: String = "+91"
    @Environment(\.dismiss) private var dismiss
    
    @State private var animate = false
    @State private var floating = false

    var body: some View {
        ZStack {
            
            // MARK: Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue,
//                    Color.indigo,
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
                .fill(Color.blue.opacity(0.15))
                .frame(width: 300)
                .blur(radius: 100)
                .offset(x: 150, y: 250)
            
            VStack(spacing: 35) {
                
                Spacer()
                
                VStack(spacing: 16) {
                    // MARK: LOck icon
                    Image(systemName: "lock.circle.fill")
                        .font(.system(size: 85))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .offset(y: floating ? -8 : 8)
                        .animation(
                            .easeInOut(duration: 2)
                                .repeatForever(autoreverses: true),
                            value: floating
                        )
                    
                    Text("Sign In with Phone")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Enter your phone number to continue")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 22) {
                    // Mark: Phone number input
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
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
