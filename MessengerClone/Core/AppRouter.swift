//
//  AppRouter.swift
//  MessengerClone
//
//  Created by rentamac on 04/02/2026.
//

import Combine
import SwiftUI
enum Route: Hashable {
    case NewChatViewNav
    case developerView
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
