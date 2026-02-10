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
    

    @Published var displayName: String = "Jacob West"
    @Published var username: String = "m.me/Jacob_d"
    @Published var phone: String = "+1 202 555 0147"
    @Published var photoURL: URL? = nil
  

    func loadUser() {
   
        //
        // guard let user = Auth.auth().currentUser else { return }
        // displayName = user.displayName ?? ""
        // photoURL = user.photoURL
        // phone = user.phoneNumber ?? ""
        //
        // if let email = user.email {
        //     username = email.components(separatedBy: "@").first ?? ""
        // } else {
        //     username = makeUsername(from: displayName)
        // }
    }
    
    // Called after editing profile (local update only for now)
    func updateLocal(name: String, photoURL: URL?, phone: String) {
        self.displayName = name
        self.photoURL = photoURL
        self.phone = phone
        
      
        // self.username = makeUsername(from: name)
    }
    

    func logout() {
        // For now just log to console so UI works.
        print("Log out tapped")
        
        // 🔜 Later, real sign‑out:
        //
        // do {
        //     try Auth.auth().signOut()
        //   
        // } catch {
        //     print("Logout error: \(error.localizedDescription)")
        // }
    }
    
    private func makeUsername(from name: String) -> String {
        name
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
    }
}

