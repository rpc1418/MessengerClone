import SwiftUI

struct HomeBottomTabView: View {

    @Binding var selectedTab: AppTab

    var body: some View {
        
        HStack {
            tabButton(
                tab: .chats,
                icon: selectedTab == .chats ? "message.fill" : "message",
                title: "Chats"
            )

            Spacer()

            tabButton(
                tab: .people,
                icon: selectedTab == .people ? "person.2.fill" : "person.2",
                title: "People"
            )

            Spacer()

            tabButton(
                tab: .discover,
                icon: selectedTab == .discover ? "safari.fill" : "safari",
                title: "Discover"
            )
            
            Spacer()
            
            tabButton(
                    tab: .profile,
                    icon: selectedTab == .profile ? "gearshape.fill" : "gearshape",
                    title: "Settings"
                )
        }
        .padding(.horizontal,40)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
        .frame(height: 10)

    }

    private func tabButton(
        tab: AppTab,
        icon: String,
        title: String
    ) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.caption)
            }
            .foregroundColor(selectedTab == tab ? .primary : .secondary)
        }
    }
}
