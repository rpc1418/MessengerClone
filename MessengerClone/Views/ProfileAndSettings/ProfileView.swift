//
//  ProfileView.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.
//
import SwiftUI
// import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
       
            List {
                headerSection
                mainSettingsSection
                preferencesSection
                accountSection
                logoutSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.white)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                      
                    }
                    .font(.system(size: 17, weight: .semibold))
                }
            }
            .onAppear {
            
                viewModel.loadUser()
            }
        
    }
    
 
    
 
    private var headerSection: some View {
        Section {
            VStack(spacing: 16) {
                // Fake Messenger code ring
                ZStack {
                    Circle()
                        .strokeBorder(Color.blue.opacity(0.3), lineWidth: 6)
                        .frame(width: 190, height: 190)
                    
                    Circle()
                        .fill(Color.blue.opacity(0.05))
                        .frame(width: 150, height: 150)
                    
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                }
                
                Text(authViewModel.appUser?.firstName ?? "User")
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
        }
        .listRowInsets(EdgeInsets())   // full‑width header like Messenger
    }
    
  
    private var mainSettingsSection: some View {
        Section {
            SettingsRow(
                systemIcon: "moon.fill",
                iconColor: Color.black,
                title: "Dark Mode",
                subtitle: nil,
                accessory: .toggle($viewModel.isDarkMode)
            )
            
            SettingsRow(
                systemIcon: "circle.fill",
                iconColor: Color.green,
                title: "Active Status",
                subtitle: "On",
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "at",
                iconColor: Color.red,
                title: "Username",
                subtitle: viewModel.username,
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "phone.fill",
                iconColor: Color.blue,
                title: "Phone",
                subtitle: viewModel.phone,
                accessory: .chevron
            )
        }
    }
    

    private var preferencesSection: some View {
        Section(header: Text("PREFERENCES")) {
            SettingsRow(
                systemIcon: "bell.fill",
                iconColor: Color.purple,
                title: "Notifications & Sounds",
                subtitle: nil,
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "person.2.fill",
                iconColor: Color.blue,
                title: "People",
                subtitle: nil,
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "book.fill",
                iconColor: Color.orange,
                title: "Story",
                subtitle: nil,
                accessory: .chevron
            )
        }
    }
    
    // Account: privacy, data saver, report, help
    private var accountSection: some View {
        Section(header: Text("ACCOUNT")) {
            SettingsRow(
                systemIcon: "lock.fill",
                iconColor: Color.gray,
                title: "Privacy & Safety",
                subtitle: nil,
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "antenna.radiowaves.left.and.right",
                iconColor: Color.green,
                title: "Data Saver",
                subtitle: nil,
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "exclamationmark.bubble.fill",
                iconColor: Color.red,
                title: "Report a Problem",
                subtitle: nil,
                accessory: .chevron
            )
            
            SettingsRow(
                systemIcon: "questionmark.circle.fill",
                iconColor: Color.blue,
                title: "Help",
                subtitle: nil,
                accessory: .chevron
            )
        }
    }
    
  
    private var logoutSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.logout()
            } label: {
                HStack {
                    Spacer()
                    Text("Log Out")
                    Spacer()
                }
            }
        }
    }
    

    
    private var profileImage: Image {
    
        Image(systemName: "person.crop.circle.fill")
    }
}



enum SettingsAccessory {
    case chevron
    case toggle(Binding<Bool>)
}

struct SettingsRow: View {
    let systemIcon: String
    let iconColor: Color
    let title: String
    let subtitle: String?
    let accessory: SettingsAccessory
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor)
                    .frame(width: 32, height: 32)
                Image(systemName: systemIcon)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                if let subtitle {
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            switch accessory {
            case .chevron:
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold))
            case .toggle(let binding):
                Toggle("", isOn: binding)
                    .labelsHidden()
            }
        }
        .padding(.vertical, 6)
    }
}



#Preview {
    NavigationStack{
        ProfileView()
    }
}
