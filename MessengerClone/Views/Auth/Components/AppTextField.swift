//
//  AppTextField.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: 16))
            .padding(.vertical, 6)
            .foregroundColor(.primary)
            .autocorrectionDisabled() 
    }
}

