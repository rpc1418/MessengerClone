//
//  AppRouter.swift
//  MessengerClone
//
//  Created by rentamac on 04/02/2026.
//

import Combine
import SwiftUI
enum Route: Hashable {
    case login
    case phoneLogin
    case otpVerification(phone: String, firstName: String?, lastName: String?, about: String?)
    case registration
    case home
    case newChat
    case developerView
    case profileView
    case chat(chat: Chat)
    case activestatusview
    case datasaverview
    case helpcenterview
    case notificationssettingsview
    case privacysafetyview
    case phonesettingsview
    case reportproblemview
    case storysettingsview
    case usernamesettingsview
    case emailLogin
    case emailRegistrationView
}



class AppRouter: ObservableObject{
    @Published var path = NavigationPath()
    func navigate(to route: Route){
        path.append(route)
    }
    func goBack(){
        path.removeLast()
    }
    func goToHome(){
        path = NavigationPath()
    }
}
