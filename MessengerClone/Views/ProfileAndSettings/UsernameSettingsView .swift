//
//  UsernameSettingsView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct UsernameSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section(header: Text("USERNAME")) {
                TextField("Username", text: $viewModel.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }

            Section(footer:
                Text("Your username is how people find you on Messenger. It must be unique.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            ) {
                Button("Save") {
                    // 🔜 TODO: write back to Firestore if your team decides to store username there
                    // For now, this keeps the local view model updated
                    print("Saving username:", viewModel.username)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Username")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Pull current value from Firebase → AuthViewModel → AppUser
            viewModel.configure(from: authViewModel.appUser)
        }
        .onChange(of: authViewModel.appUser?.id) { _ in
            viewModel.configure(from: authViewModel.appUser)
        }
    }
}

#Preview {
    NavigationStack {
        UsernameSettingsView()
            .environmentObject(AuthViewModel())
    }
}
