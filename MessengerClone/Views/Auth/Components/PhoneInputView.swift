//
//  PhoneInputView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

/// Phone number input with country code selector
struct PhoneInputView: View {
    @Binding var countryCode: String
    @Binding var phoneNumber: String

    var body: some View {
        HStack(spacing: 12) {

            // Country code dropdown
            Menu {
                Button("+91  India") { countryCode = "+91" }
                Button("+1   USA") { countryCode = "+1" }
                Button("+44  UK") { countryCode = "+44" }
            } label: {
                Text(countryCode)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
            }

            // Divider between code & number
            Divider()
                .frame(height: 24)

            // Phone number input
            TextField("Phone number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .font(.system(size: 16))
        }
        .padding(.vertical, 6)
    }
}

