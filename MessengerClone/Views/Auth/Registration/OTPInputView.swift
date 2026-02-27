//
//  OTPInputView.swift
//  MessengerClone
//
//  Created by rentamac on 2/6/26.
//

import SwiftUI

struct OTPInputView: View {

    @Binding var otp: String

    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<6, id: \.self) { index in
                otpBox(at: index)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
        .background(hiddenTextField)
    }

    private func otpBox(at index: Int) -> some View {
        let character = characterAt(index)

        return Text(character)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(width: 48, height: 54)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        index == otp.count
                        ? Color.blue
                        : Color.gray.opacity(0.2),
                        lineWidth: 1.5
                    )
            )
    }

    private var hiddenTextField: some View {
        TextField("", text: $otp)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .focused($isFocused)
            .frame(width: 0, height: 0)
            .opacity(0.01)
            .onChange(of: otp) { newValue in
                if newValue.count > 6 {
                    otp = String(newValue.prefix(6))
                }
            }
    }

    private func characterAt(_ index: Int) -> String {
        guard index < otp.count else { return "" }
        return String(Array(otp)[index])
    }
}
