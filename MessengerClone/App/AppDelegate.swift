//
//  AppDelegate.swift
//  MessengerClone
//
//  Created by rentamac on 08/02/2026.
//


import SwiftUI
import FirebaseCore
import FirebaseAuth

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

    func application(_ application: UIApplication,
                    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("AppDelegate: Received remote notification")
        if Auth.auth().canHandleNotification(userInfo) {
            print("Firebase Auth handled notification")
            completionHandler(.newData)
        } else {
            completionHandler(.noData)
        }
    }
    
    func application(_ application: UIApplication,
                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("AppDelegate: Registered for remote notifications")
    }
    
    func application(_ application: UIApplication,
                    didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("AppDelegate: Failed to register remote notifications: \(error.localizedDescription)")
    }
}






