//
//  MockChatData.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//
import Foundation

struct MockChat {
    let id: UUID = UUID()
    let name: String
    let lastMessage: String
    let time: String
}

let mockChats: [MockChat] = [
    MockChat(name: "Martin Randolph", lastMessage: "You: What's man", time: "9:40 AM"),
    MockChat(name: "Andrew Parker", lastMessage: "Ok, thanks!", time: "9:25 AM"),
    MockChat(name: "Karen Castillo", lastMessage: "You: See you", time: "Fri"),
    MockChat(name: "Maisy Humphrey", lastMessage: "Have a good day", time: "Fri"),
    MockChat(name: "Joshua Lawrence", lastMessage: "The business plan loo...", time: "Thu")
]

