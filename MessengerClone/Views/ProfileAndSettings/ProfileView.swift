//
//  ProfileView.swift
//  MessengerClone
//
//  Created by rentamac on 03/02/2026.





import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: AppRouter

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
        .navigationTitle("Profile And Settings")
        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Done") {
//                    router.goBack()    // go back in NavigationStack
//                }
//                .font(.system(size: 17, weight: .semibold))
//            }
//        }
        .onAppear {
            viewModel.configure(from: authViewModel.appUser)
        }
        .onChange(of: authViewModel.appUser?.id) { _ in
            viewModel.configure(from: authViewModel.appUser)
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        Section {
            VStack(spacing: 16) {
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

                Text(viewModel.displayName.isEmpty ? "User" : viewModel.displayName)
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
        }
        .listRowInsets(EdgeInsets())
    }

    private var mainSettingsSection: some View {
        Section {
            // Dark Mode toggle - stays on this screen
            SettingsRow(
                systemIcon: "moon.fill",
                iconColor: Color.black,
                title: "Dark Mode",
                subtitle: nil,
                accessory: .toggle($viewModel.isDarkMode)
            )

            // Active Status -> placeholder navigation
            Button {
                // Adjust route later if team adds a specific screen
                router.navigate(to: .activestatusview)
            } label: {
                SettingsRow(
                    systemIcon: "circle.fill",
                    iconColor: Color.green,
                    title: "Active Status",
                    subtitle: "On",
                    accessory: .chevron
                )
            }

            // Username row
            Button {
                // Example: go to developerView until an edit screen exists
                router.navigate(to: .usernamesettingsview)
            } label: {
                SettingsRow(
                    systemIcon: "at",
                    iconColor: Color.red,
                    title: "Username",
                    subtitle: viewModel.username,
                    accessory: .chevron
                )
            }

            // Phone row
            Button {
                // Reuse phone login screen for now
                router.navigate(to: .phonesettingsview)
            } label: {
                SettingsRow(
                    systemIcon: "phone.fill",
                    iconColor: Color.blue,
                    title: "Phone",
                    subtitle: viewModel.phone,
                    accessory: .chevron
                )
            }
        }
    }

    private var preferencesSection: some View {
        Section(header: Text("PREFERENCES")) {
            Button {
                router.navigate(to: .notificationssettingsview)
            } label: {
                SettingsRow(
                    systemIcon: "bell.fill",
                    iconColor: Color.purple,
                    title: "Notifications & Sounds",
                    subtitle: nil,
                    accessory: .chevron
                )
            }

            Button {
                // PeopleView is mapped to .newChat in your router
                router.navigate(to: .newChat)
            } label: {
                SettingsRow(
                    systemIcon: "person.2.fill",
                    iconColor: Color.blue,
                    title: "People",
                    subtitle: nil,
                    accessory: .chevron
                )
            }

            Button {
                router.navigate(to: .storysettingsview)
            } label: {
                SettingsRow(
                    systemIcon: "book.fill",
                    iconColor: Color.orange,
                    title: "Story",
                    subtitle: nil,
                    accessory: .chevron
                )
            }
        }
    }

    private var accountSection: some View {
        Section(header: Text("ACCOUNT")) {
            Button { router.navigate(to: .privacysafetyview) } label: {
                SettingsRow(
                    systemIcon: "lock.fill",
                    iconColor: Color.gray,
                    title: "Privacy & Safety",
                    subtitle: nil,
                    accessory: .chevron
                )
            }

            Button { router.navigate(to: .datasaverview) } label: {
                SettingsRow(
                    systemIcon: "antenna.radiowaves.left.and.right",
                    iconColor: Color.green,
                    title: "Data Saver",
                    subtitle: nil,
                    accessory: .chevron
                )
            }

            Button { router.navigate(to: .reportproblemview) } label: {
                SettingsRow(
                    systemIcon: "exclamationmark.bubble.fill",
                    iconColor: Color.red,
                    title: "Report a Problem",
                    subtitle: nil,
                    accessory: .chevron
                )
            }

            Button { router.navigate(to: .helpcenterview) } label: {
                SettingsRow(
                    systemIcon: "questionmark.circle.fill",
                    iconColor: Color.blue,
                    title: "Help",
                    subtitle: nil,
                    accessory: .chevron
                )
            }
        }
    }

    private var logoutSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.logout(using: authViewModel)
                router.goToHome()
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
        if let url = viewModel.photoURL,
           let data = try? Data(contentsOf: url),
           let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle.fill")
        }
    }
}

// MARK: - SettingsRow and accessory

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

// MARK: - Preview

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(AppRouter())
            .environmentObject(AuthViewModel())
    }
}
