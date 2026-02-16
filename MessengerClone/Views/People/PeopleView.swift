//
//  People.swift
//  MessengerClone
//
//  Created by rentamac on 15/02/2026.
//


import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject private var viewModel : ContactsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isMultiSelectEnabled = false
     
    
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
                        Button("Clear the message"){
                            viewModel.msgFromViewModel = ""
                        }
                        Spacer()
                    }
                    
                    else {
                        List() {

                            Section("Registered Users") {
                                ForEach(viewModel.filteredContacts(type: 0)) { contact in
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
                                
                            }

                            Section("Not Registered Users") {
                                ForEach(viewModel.filteredContacts(type: 1), id: \.objectID) { contact in
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
                            }
                        }
                        .environment(\.editMode, .constant(isMultiSelectEnabled ? .active : .inactive))
                        .listStyle(.plain)


                    }
                        
                        
                    
                        
                    
                    
                }
                .toolbar(
                    content: {
                        ToolbarItem(placement: .topBarLeading){
                            Button(action:{
                                if isMultiSelectEnabled{
                                    isMultiSelectEnabled.toggle()
                                }else{
                                    router.goBack()
                                }
                                
                            }){
                                if isMultiSelectEnabled{
                                    Text("Deselect\(viewModel.selectedContactIDs.count)")
                                }else{
                                    Text("Cancel")
                                }
                            }
                            .foregroundStyle(Color.blue)
                            .backgroundExtensionEffect(isEnabled: false)
                           
                        }
                        ToolbarItem(placement: .principal){
                            Text("Contacts")
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button(action:{
                                Task{
                                    await viewModel.requestAndSyncContacts()
                                }
                                
                                
                            }){
                               Image(systemName: "arrow.clockwise")
                            }
                            .foregroundStyle(Color.blue)
                            .backgroundExtensionEffect(isEnabled: false)
                           
                        }
                    }
                )
            
            
            
        }
        .navigationBarBackButtonHidden()
        
            
    }
}



extension RegisteredContact {
    var fullName: String {
        "\(firstName ?? "") \(lastName ?? "")"
    }
}
