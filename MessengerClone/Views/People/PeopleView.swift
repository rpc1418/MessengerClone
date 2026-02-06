//
//  PeopleView.swift
//  MessengerClone
//
//  Created by rentamac on 04/02/2026.
//

import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var router: AppRouter
    @StateObject private var viewModel = ContactsViewModel()
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea(.all)
           
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
                        List(viewModel.filteredContacts) { contact in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(contact.name)
                                    .font(.headline)
                                
                                ForEach(contact.phoneNumbers, id: \.self) { phone in
                                    Text(phone)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .onTapGesture {
                                    print(contact.name)
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                        
                        
                    
                        
                    
                    
                }
                .toolbar(
                    content: {
                        ToolbarItem(placement: .topBarLeading){
                            Button(action:{
                                router.goToHome()
                            }){
                                Text("Cancel")
                            }
                            .foregroundStyle(Color.foreground)
                            .backgroundExtensionEffect(isEnabled: false)
                           
                        }
                        ToolbarItem(placement: .principal){
                            Text("Contacts")
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button(action:{
                                viewModel.requestAndFetchContacts()
                            }){
                               Image(systemName: "arrow.clockwise")
                            }
                            .foregroundStyle(Color.foreground)
                            .backgroundExtensionEffect(isEnabled: false)
                           
                        }
                    }
                )
            
            
            
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.requestAndFetchContacts()
        }
            
    }
}



