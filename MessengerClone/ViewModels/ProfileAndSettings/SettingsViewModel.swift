//
//  SettingsViewModel.swift
//  MessengerClone
//
//  Created by rentamac on 05/02/2026.
//


import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    // UI toggles
    @Published var isDarkMode: Bool = false
    @Published var isActiveStatusOn: Bool = true
    @Published var notificationsOn: Bool = true

    // User display fields
    @Published var displayName: String = ""
    @Published var username: String = ""
    @Published var phone: String = ""
    @Published var photoURL: URL? = nil

    /// Fill properties from AppUser (comes from AuthViewModel)
    func configure(from appUser: AppUser?) {
        guard let user = appUser else {
            displayName = "User"
            username = ""
            phone = ""
            photoURL = nil
            return
        }

        // Name
        if user.firstName.isEmpty && user.lastName.isEmpty {
            displayName = "User"
        } else {
            displayName = "\(user.firstName) \(user.lastName)"
        }

        // Simple username style
        username = "m.me/\(user.firstName.lowercased())"

        // Phone
        phone = user.phoneNumber

        // Optional profile URL
        if let urlString = user.profileURL,
           let url = URL(string: urlString) {
            photoURL = url
        } else {
            photoURL = nil
        }
    }

    /// Local update (for future edit profile screen)
    func updateLocal(name: String, photoURL: URL?, phone: String) {
        self.displayName = name
        self.photoURL = photoURL
        self.phone = phone
    }

    /// Delegate logout to AuthViewModel
    func logout(using authViewModel: AuthViewModel) {
        authViewModel.signOut()
    }
}
