//
//  HomeSearchBarView.swift
//  MessengerClone
//
//  Created by rentamac on 2/5/26.
//

import Foundation
import SwiftUI

struct HomeSearchBarView: View {
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                
            Text("Search")
                .foregroundColor(.gray)
            
            Spacer()
                
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

