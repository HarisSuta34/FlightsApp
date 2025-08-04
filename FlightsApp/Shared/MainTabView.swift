//
//  MainTabView.swift
//

import SwiftUI
import GoogleSignIn

// Pretpostavimo da su LoginScreenViewModel, HomeScreenView,
// PlaceholderOffersView i ProfileScreenView već definisani.

struct MainTabView: View {
    @StateObject private var loginScreenViewModel = LoginScreenViewModel()
    @StateObject private var homeScreenViewModel = HomeScreenViewModel()

    var body: some View {
        // Koristimo 'isLoggedIn' property iz vašeg ViewModela
        if loginScreenViewModel.isLoggedIn {
            TabView {
                // Home Tab
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
                
                // Offers Tab (placeholder)
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
                
                // Profile Tab
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
                    // Pozivamo ispravnu metodu iz vašeg ViewModela
                    loginScreenViewModel.loadLoginStateIfNeeded()
                }
        }
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}
