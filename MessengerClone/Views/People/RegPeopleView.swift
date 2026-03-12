//
//  PeopleView.swift
//  MessengerClone
//
//  Created by rentamac on 04/02/2026.
//
import SwiftUI

struct RegPeopleView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject private var authViewModel: AuthViewModel
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
                    .padding(.horizontal, 12)
                    .frame(height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color(.systemGray5))
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
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
                                Task {
                                do {
                                    viewModel.isLoading = true
                                    let chat = try await viewModel.createChat(
                                        currentUserID: authViewModel.appUser!.uid,
                                        contact: contact
                                    )
                                    viewModel.isLoading = false
                                    router.navigate(to: .chat(chat: chat))
                                    
                                    
                                } catch {
                                    viewModel.isLoading = false
                                }
                            }
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


