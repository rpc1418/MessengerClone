//
//  ChatAlertType.swift
//  MessengerClone
//
//  Created by rentamac on 25/02/2026.
//

import Foundation

enum AlertType: Identifiable {
    case phone
    case video
    case mic
    case camera
    
    var id: String {
        switch self {
        case .phone: return "phone"
        case .video: return "video"
        case .mic: return "mic"
        case .camera: return "camera"
        }
    }
    
    var title: String {
        switch self {
        case .phone:
            return "Voice Call Not Supported"
        case .video:
            return "Video Call Not Supported"
        case .mic:
            return "Voice Message Not Supported"
        case .camera:
            return "Camera Not Supported"
        }
    }
    
    var message: String {
        switch self {
        case .phone:
            return "Voice calling is not available in this version."
        case .video:
            return "Video calling is not available in this version."
        case .mic:
            return "Voice messages are not available in this version."
        case .camera:
            return "Camera feature is not available in this version."
        }
    }
}
