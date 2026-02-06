//
//  MockStoryData.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import Foundation

struct MockStory {
    let id: UUID = UUID()
    let name: String
}

let mockStories: [MockStory] = [
    MockStory(name: "Your Story"),
    MockStory(name: "Hannah"),
    MockStory(name: "Karen"),
    MockStory(name: "Martin"),
    MockStory(name: "John"),
    MockStory(name: "Alex")
]

