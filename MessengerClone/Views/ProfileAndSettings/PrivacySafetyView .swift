//
//  PrivacySafetyView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct PrivacySafetyView: View {
    @State private var blockedUsers = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        Form {
            Section(header: Text("MESSAGES")) {
                Toggle("Send read receipts", isOn: $authViewModel.readReceipts)
                NavigationLink("Blocked people") {
                    Text("Blocked users list here")
                        .navigationTitle("Blocked")
                }
            }

            Section(footer:
                Text("Control who can contact you and what information you share.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            ) {
                EmptyView()
            }
        }
        .navigationTitle("Privacy & Safety")
        .navigationBarTitleDisplayMode(.inline)
    }
}

