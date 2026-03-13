//
//  ReportProblemView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct ReportProblemView: View {
    @State private var description: String = ""

    var body: some View {
        Form {
            Section(header: Text("WHAT WENT WRONG?")) {
                TextEditor(text: $description)
                    .frame(minHeight: 120)
            }

            Section {
                Button("Send Report") {
                    // TODO: send to your backend / email
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Report a Problem")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ReportProblemView()
    }
}
