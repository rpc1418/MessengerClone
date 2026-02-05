//
//  RegistrationView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var about = ""
    @State private var countryCode = "+91"
    @State private var phoneNumber = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 10) {
                    Text("Create your profile")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("This is how your friends will see you")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 10)

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

             
                PrimaryButton(title: "Continue") {

                    // Backend logic

                }
                .padding(.top, 10)
                
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
    RegistrationView()
}
