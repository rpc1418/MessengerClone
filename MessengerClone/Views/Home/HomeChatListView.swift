//
//  HomeChatListView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct HomeChatListView: View {
    var body: some View {
        List {
            ForEach(mockChats, id: \.id) { chat in
                HomeChatRowView(chat: chat)
            }
        }
        .listStyle(.plain)
    }
}
