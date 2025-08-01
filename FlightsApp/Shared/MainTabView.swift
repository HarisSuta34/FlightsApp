import SwiftUI

struct MainTabView: View {
    @ObservedObject var viewModel: LoginScreenViewModel

    var body: some View {
        TabView {
            NavigationStack {
                HomeScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
            }
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .padding(.vertical, 20)
            }

            NavigationStack {
                ProfileScreenView(viewModel: viewModel)
            }
            .tabItem {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .padding(.vertical, 20)
                
            }
        }
        .accentColor(.blue)
        .onAppear {
            
            UITabBar.appearance().backgroundColor = UIColor.white
            UITabBar.appearance().tintColor = UIColor.blue 
        }
    }
}

#Preview {
    MainTabView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
