//
//  AppUser.swift
//  MessengerClone
//
//  Created by rentamac on 2/8/26.
//

import FirebaseCore

struct AppUser: Identifiable {
    
    let id: String          
    let uid: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let about: String
    let profileURL: String?
    let createdAt: Timestamp
    let email: String?
}

