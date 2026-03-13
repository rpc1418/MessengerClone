//
//  PhoneSettingsView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct PhoneSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var router: AppRouter
    var countryCode: String = "+91"

    var body: some View {
        Form {
            Section(header: Text("PHONE NUMBER")) {
                Text(authViewModel.appUser?.phoneNumber ?? "")
                    .keyboardType(.phonePad)
            }
            
            Button(
                action: {
                    Task {
                        let fullPhone = authViewModel.appUser?.phoneNumber ?? ""
                        await authViewModel.sendOTP(phoneNumber: fullPhone)
                        print(authViewModel.appUser?.phVerified)
                        if authViewModel.errorMessage == nil {
                            router.navigate(
                                to: .otpVerification(
                                    phone: fullPhone,
                                    firstName: "",
                                    lastName: "",
                                    about: "",
                                    fromView: "PhoneSettingsView"
                                )
                            )
                        }
                    }
                }
                
            ) {
                Text(authViewModel.isLoading ? "Sending OTP..." : (authViewModel.appUser?.phVerified == "Verified") ? "Verified" : "Verify")
            }
            
            .disabled(authViewModel.isLoading || authViewModel.appUser?.phVerified == "Verified")
            Text("This is the phone number linked to your Messenger account.")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .navigationTitle("Phone")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Load current phone from AppUser (Firestore)
            viewModel.configure(from: authViewModel.appUser)
        }
        .onChange(of: authViewModel.appUser?.id) { _ in
            viewModel.configure(from: authViewModel.appUser)
        }
    }
}

#Preview {
    NavigationStack {
        PhoneSettingsView()
            .environmentObject(AuthViewModel())
    }
}
