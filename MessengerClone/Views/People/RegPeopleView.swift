//
//  PeopleView.swift
//  MessengerClone
//
//  Created by rentamac on 04/02/2026.
//
import SwiftUI

struct RegPeopleView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject private var viewModel: ContactsViewModel
    var body: some View {
        ZStack{
            Color(.systemBackground).ignoresSafeArea()
           
                VStack(spacing:0)   {
                    HStack{
                        Text("To:")
                        TextField(
                            "Search Field",
                            text: $viewModel.searchText,
                            prompt: Text("Type name or number here")
                        )
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.foreground.opacity(0.1))
                    .padding(.top,1)
                    if viewModel.isLoading{
                        Spacer()
                        Text("Loading..")
                        Spacer()
                    } else if viewModel.msgFromViewModel != ""
                    {
                        Spacer()
                        Text(viewModel.msgFromViewModel)
                        Spacer()
                    }
                    
                    else {
                        List(viewModel.filteredContacts(type: 0), id: \.objectID) { contact in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.fullName)
                                    .font(.headline)
                                Text(contact.isReg ? "reg user" : "not reg user")

                                if let phone = contact.idPhNo {
                                    Text(phone)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print(contact.fullName)
                            }
                        }
                        .listStyle(.plain)

                    }
                        
                     
                    
                    
                }
                
            
            VStack {
                   Spacer()
                   HStack {
                       Spacer()
                       Button {
                           print("refreshing")
                           Task {
                               await viewModel.requestAndSyncContacts()
                           }
                       } label: {
                           Image(systemName: "arrow.clockwise")
                               .padding()
                               .background(Color.blue)
                               .foregroundColor(.white)
                               .clipShape(Circle())
                       }
                       .padding()
                   }
               }
           }
        .navigationBarBackButtonHidden()
        .onAppear {
            
        }
            
    }
}


