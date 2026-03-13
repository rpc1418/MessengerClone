//
//  NotificationsSettingsView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @State private var messageAlerts = true
    @State private var sound = true
    @State private var vibration = true

    var body: some View {
        Form {
            Section(header: Text("MESSAGE ALERTS")) {
                Toggle("Show notifications", isOn: $messageAlerts)
                Toggle("Sound", isOn: $sound)
                Toggle("Vibration", isOn: $vibration)
            }

            Section {
                Button("Manage system notification settings") {
                    // Usually opens iOS Settings via URL if needed
                }
            }
        }
        .navigationTitle("Notifications & Sounds")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationsSettingsView()
    }
}
