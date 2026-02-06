//
//  HomeView.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.
//
import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            HomeTopBarView()
            HomeSearchBarView()
            HomeStoriesView()
            HomeChatListView()
            Spacer()
            HomeBottomTabView()
        }
    }
}

#Preview {
    HomeView()
}


