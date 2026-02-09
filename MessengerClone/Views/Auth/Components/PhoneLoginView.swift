import SwiftUI

struct PhoneLoginView: View {

    @EnvironmentObject var viewModel: AuthViewModel
    @Binding var phoneNumber: String
    @Binding var countryCode: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
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
                    title: viewModel.isLoading ? "Sending OTP..." : "Continue",
                    icon: "arrow.right",
                    isLoading: viewModel.isLoading
                ) {
                    Task {
                        let fullPhone = countryCode + phoneNumber
                        await viewModel.sendOTP(phoneNumber: fullPhone)
                    }
                }
                .disabled(phoneNumber.isEmpty || viewModel.isLoading)

                SecondaryButtons("Back to Login") {
                    dismiss()
                }

                if let error = viewModel.errorMessage {
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
            .navigationDestination(item: $viewModel.otpNavigationTrigger) { _ in
                OTPVerificationView(
                    viewModel: viewModel,
                    firstName: "",
                    lastName: "",
                    about: "",
                    phoneNumber: countryCode + phoneNumber
                )
            }
        }
    }
}
