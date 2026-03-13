//
//  Message.swift
//  MessengerClone
//
//  Created by rentamac on 08/02/2026.
//

import Foundation
import FirebaseFirestore
struct Message: Identifiable , Equatable{
    let id: String
    let senderID: String
    let text: String
    let timestamp: Timestamp
    let readBy: [String]
}

extension Message {
    var date: Date {
        timestamp.dateValue()
    }
    
    var timestampFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
