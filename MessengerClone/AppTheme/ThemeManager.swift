//
//  ThemeManager.swift
//  MessengerClone
//
//  Created by rentamac on 2/18/26.
//
import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {
    
    @AppStorage("selectedTheme") var selectedTheme: String = "system"

    var colorScheme: ColorScheme? {
        switch selectedTheme {
        case "dark": return .dark
        case "light": return .light
        default: return nil // system default colour
        }
    }
}


