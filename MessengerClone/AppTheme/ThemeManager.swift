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
    
    @Published var isDarkMode: Bool = false
    
    var colorScheme: ColorScheme? {
        isDarkMode ? .dark : .light
    }
}

