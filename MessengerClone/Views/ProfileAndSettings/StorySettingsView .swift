//
//  StorySettingsView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct StorySettingsView: View {
    @State private var storyPrivacy = "Friends"
    let options = ["Public", "Friends", "Only Me"]

    var body: some View {
        Form {
            Section(header: Text("WHO CAN SEE YOUR STORY")) {
                Picker("Story privacy", selection: $storyPrivacy) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.inline)
            }

            Section(footer:
                Text("These settings control who can view your Messenger stories.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            ) {
                EmptyView()
            }
        }
        .navigationTitle("Story")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        StorySettingsView()
    }
}
