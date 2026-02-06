//
//  HomeTopBarView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import Foundation
import SwiftUI

struct HomeTopBarView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
            
            Text("Chats")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Image(systemName: "camera.fill")
                .font(.title2)
                .padding(.horizontal)
            
            Image(systemName: "square.and.pencil")
                .font(.title2)
            
        }
        .padding()
    }
}

