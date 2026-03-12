import SwiftUI

struct HomeView: View {

    @EnvironmentObject var appRouter: AppRouter
    @State private var selectedTab: AppTab = .chats
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {

        ZStack(alignment: .top) {

            

            // DYNAMIC CONTENT
            
            TabView(selection: $selectedTab){
                Tab("Chats", systemImage: "message.fill" , value: .chats){
                    ScrollView{
                        currentScreen
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                            .background(Color(.systemBackground))
                    }
                }
                Tab("People", systemImage: "person.2.fill" ,value: .people){
                    currentScreen
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                }
                Tab("Discover", systemImage: "safari.fill" ,value: .discover){
                    ScrollView{
                        currentScreen
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    }
                    
                }
                Tab("Settings", systemImage: "gearshape.fill" ,value: .profile ){
                    ScrollView{
                        currentScreen
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemBackground))
                    }
                }
        }
            
            // STATIC TOP BAR
            HomeTopBarView(
                selectedTab: selectedTab,
            )
        .navigationBarHidden(true)
        }
        .ignoresSafeArea(.keyboard)
    }
}


private extension HomeView {

    @ViewBuilder
    var currentScreen: some View {
        ZStack{
            switch selectedTab  {
            case .chats:
                HomeChatsView()

            case .people:
                RegPeopleView()

            case .discover:
                DiscoverView()
                
            case .profile:
                ProfileView()
            }
        }
        
            .padding(.top,70)
        
        
    }
        
    func handleProfileTap() {
        appRouter.navigate(to: .profileView)
    }
}


