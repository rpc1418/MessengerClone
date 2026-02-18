//
//  ActiveStatusView.swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct ActiveStatusView: View {
    @State private var isActive = true

    var body: some View {
        Form {
            Section {
                Toggle("Show when you're active", isOn: $isActive)
            } footer: {
                Text("If you turn this off, you won’t be able to see when your friends are active either.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Active Status")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ActiveStatusView()
    }
}
