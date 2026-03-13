//
//  DataSaverView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct DataSaverView: View {
    @State private var dataSaverOn = false
    @State private var autoPlayMediaOnWifi = true

    var body: some View {
        Form {
            Section {
                Toggle("Data Saver", isOn: $dataSaverOn)
            } footer: {
                Text("When Data Saver is on, photos and videos may load at lower quality to save data.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Section(header: Text("MEDIA")) {
                Toggle("Auto-play media on Wi‑Fi", isOn: $autoPlayMediaOnWifi)
            }
        }
        .navigationTitle("Data Saver")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DataSaverView()
    }
}
