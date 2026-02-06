//
//  HomeBottomTabView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct HomeBottomTabView: View {
    var body: some View {
        HStack {
            Spacer()

            VStack {
                Image(systemName: "message.fill")
                Text("Chats")
                    .font(.caption)
            }
            .foregroundColor(.black)

            Spacer()

            VStack {
                Image(systemName: "person.2")
                Text("People")
                    .font(.caption)
            }

            Spacer()

            VStack {
                Image(systemName: "safari")
                Text("Discover")
                    .font(.caption)
            }

            Spacer()
        }
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
    }
}
