//
//  HelpCenterView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        List {
            Section {
                NavigationLink("FAQs") {
                    Text("Frequently asked questions")
                        .padding()
                        .navigationTitle("FAQs")
                }
                NavigationLink("Contact support") {
                    Text("Support options here")
                        .padding()
                        .navigationTitle("Support")
                }
            }

            Section(footer:
                Text("This is a static help center for now. Later it can pull articles from a backend.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            ) {
                EmptyView()
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HelpCenterView()
    }
}
