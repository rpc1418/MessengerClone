//
//  HomeStoriesView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import SwiftUI

struct HomeStoriesView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(mockStories, id: \.id) { story in
                    VStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)

                        Text(story.name)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
    }
}
