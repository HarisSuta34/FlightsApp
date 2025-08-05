import SwiftUI
import GoogleSignIn

struct MainTabView: View {
    @StateObject private var loginScreenViewModel = LoginScreenViewModel()
    @StateObject private var homeScreenViewModel = HomeScreenViewModel()

    var body: some View {
        if loginScreenViewModel.isLoggedIn {
            TabView {
                NavigationStack {
                    HomeScreenView(
                        homeScreenViewModel: homeScreenViewModel,
                        loginScreenViewModel: loginScreenViewModel
                    )
                }
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .padding(.vertical, 20)
                }
                
                NavigationStack {
                    PlaceholderOffersView()
                }
                .tabItem {
                    VStack {
                        Image(systemName: "airplane")
                        Text("Offers")
                    }
                    .padding(.vertical, 20)
                }
                
                NavigationStack {
                    ProfileScreenView(viewModel: loginScreenViewModel)
                }
                .tabItem {
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .padding(.vertical, 20)
                }
            }
            .tint(.blue)
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor.white
                UITabBar.appearance().tintColor = UIColor.blue
            }
        } else {
            LoginScreenView(viewModel: loginScreenViewModel)
                .onAppear {
                    loginScreenViewModel.loadLoginStateIfNeeded()
                }
        }
    }
}

#Preview {
    MainTabView()
}
