//
//  Contact.swift
//  MessengerClone
//
//  Created by rentamac on 05/02/2026.
//

import Foundation

struct PhoneContact: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumbers: [String]
}
