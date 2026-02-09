//
//  AppDelegate.swift
//  MessengerClone
//
//  Created by rentamac on 08/02/2026.
//


import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("App Started")
      if let app = FirebaseApp.app() {
             print("Firebase configured successfully")
         } else {
             print("Firebase not configured")
         }
    return true
  }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("App moved to background")
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("App entering foreground")
    }

}
