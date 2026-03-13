//
//  SecondaryButtons.swift
//  MessengerClone
//
//  Created by rentamac on 2/7/26.
//

import SwiftUI

struct SecondaryButtons: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .cornerRadius(16)
                .shadow(color: .blue.opacity(0.2), radius: 5)
        }
    }
}
