//
//  PhoneSettingsView .swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//

import SwiftUI

struct PhoneSettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section(header: Text("PHONE NUMBER")) {
                Text(viewModel.phone)
                    .keyboardType(.phonePad)
            }

          
                Text("This is the phone number linked to your Messenger account.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            
        }
        .navigationTitle("Phone")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Load current phone from AppUser (Firestore)
            viewModel.configure(from: authViewModel.appUser)
        }
        .onChange(of: authViewModel.appUser?.id) { _ in
            viewModel.configure(from: authViewModel.appUser)
        }
    }
}

#Preview {
    NavigationStack {
        PhoneSettingsView()
            .environmentObject(AuthViewModel())
    }
}
