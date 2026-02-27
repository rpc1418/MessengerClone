import SwiftUI

struct HomeTopBarView: View {
    
    let selectedTab: AppTab
    var profileImage: Image? = nil
    var onFirstActionTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            
            // Left: Avatar + Title
            HStack(spacing: 12) {
                avatarView
                titleView
            }
            
            Spacer()
            
            // Right Action Buttons
            HStack(spacing: 16) {
                if let firstIcon = firstIcon {
                    actionButton(systemName: firstIcon) {
                        onFirstActionTap?()
                    }
                }
                
                if let secondIcon = secondIcon {
                    actionButton(systemName: secondIcon) {
                        handleSecondAction()
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        .overlay(
            Divider(),
            alignment: .bottom
        )
    }
}

private extension HomeTopBarView {
    
    // MARK: - Title
    
    var title: String {
        switch selectedTab {
        case .chats: return "Chats"
        case .people: return "People"
        case .discover: return "Discover"
        case .profile: return "Settings"
        }
    }
    
    var titleView: some View {
        Text(title)
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
    
    // MARK: - Icons Logic
    
    var firstIcon: String? {
        switch selectedTab {
        case .chats: return "camera"
        case .people: return "message"
        case .discover: return nil
        case .profile: return nil
        }
    }
    
    var secondIcon: String? {
        switch selectedTab {
        case .chats: return "square.and.pencil"
        case .people: return "person.badge.plus"
        case .discover: return nil
        case .profile: return nil
        }
    }
    
    // MARK: - Components
    
    func actionButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                
                Image(systemName: systemName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
            }
        }
        .buttonStyle(.plain)
    }
    
    // Avatar (Non-clickable)
    var avatarView: some View {
        ZStack {
            Circle()
                .fill(Color(.systemGray5))
                .frame(width: 40, height: 40)
            
            if let profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(.primary)
            }
        }
    }
    
    // MARK: - Internal Actions
    
    func handleSecondAction() {
        
    }
}
