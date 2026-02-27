//
//  People.swift
//  MessengerClone
//
//  Created by rentamac on 15/02/2026.
//


import SwiftUI
import CoreData

struct PeopleView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject private var viewModel : ContactsViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isMultiSelectEnabled = false
     
    @State private var inviteContact: RegisteredContact?
    @State private var showInviteDialog = false
    @State private var groupName: String = ""
    
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
                        if viewModel.selectedContactIDs.count >= 2{
                            HStack{
                                Text("Group Name:")
                                TextField(
                                    "Group Name",
                                    text: $groupName,
                                    prompt: Text("Enter Group Name Here")
                                )
                                
                            }
                            
                            .padding()
                            .background(Color.foreground.opacity(0.1))
                            .padding(.top,1)
                            Button("Create Group"){
//                                print(viewModel.selectedContactIDs)
                                Task{
                                    do{
                                        let chat = try await viewModel.createGroupChat(groupName: groupName, CurUserID: authViewModel.appUser!.uid)
                                        router.navigate(to: .chat(chat: chat))
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                            }
                            .disabled(groupName.isEmpty)
                        }
                        List(selection: $viewModel.selectedContactIDs) {
                            Section("Registered Users") {
                                ForEach(viewModel.filteredContacts(type: 0), id: \.objectID) { contact in
                                    ContactRowView(
                                        contact: contact,
                                        onTap: { tappedContact in
                                            Task {
                                                do {
                                                    print("tapped")
                                                    viewModel.isLoading = true
                                                    let chat = try await viewModel.createChat(
                                                        currentUserID: authViewModel.appUser!.uid,
                                                        contact: tappedContact
                                                    )
                                                    viewModel.isLoading = false
                                                    router.navigate(to: .chat(chat: chat))
                                                    
                                                    
                                                } catch {
                                                    viewModel.isLoading = false
                                                    print("Failed to create/fetch chat:", error)
                                                }
                                            }
                                        },

                                        isMultiSelectEnabled: $isMultiSelectEnabled,
                                        selectedContactIDs: $viewModel.selectedContactIDs
                                    )
                                }
                            }
                            if !isMultiSelectEnabled{
                                Section("Not Registered Users") {
                                    ForEach(viewModel.filteredContacts(type: 1), id: \.objectID) { contact in
                                        ContactRowView(
                                            contact: contact,
                                            onTap: {
                                                tappedContact in
                                                    
                                                    inviteContact = tappedContact
                                                    showInviteDialog = true
                                                
                                            },
                                            isMultiSelectEnabled: $isMultiSelectEnabled,
                                            selectedContactIDs: $viewModel.selectedContactIDs
                                        )
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
        .confirmationDialog(
            "Invite \(inviteContact?.idPhNo ?? "") to MessengerClone?",
            isPresented: $showInviteDialog,
            titleVisibility: .visible
        ) {
            Button("Send SMS Invite") {
                viewModel.sendInviteSMS(phone: inviteContact?.idPhNo ?? "")
            }

            Button("Cancel", role: .cancel) {}
        }

            
    }
}



