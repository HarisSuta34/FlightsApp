//
//  HomeScreenView.swift
//  FlightsApp
//
//  Created by Haris Suta on 25. 7. 2025..
//

import SwiftUI

struct HomeScreenView: View {
    var body: some View {
        NavigationView{
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)
                
                Text("Home")
                    .font(.system(size: 80, weight: .bold, design: .default))
                    .foregroundColor(.white)
                    .padding(.bottom, 300)
                
            }
            
            .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            NavigationLink(destination:HomeScreenView()){
                                VStack{
                                    Image(systemName: "house.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                    Text("Home")
                                        .foregroundColor(.blue)
                                }
                                .padding(.top, 20)
                                .padding(.leading, 20)
                            }
                            NavigationLink(destination:ProfileScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))){
                                VStack{
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                    Text("Profile")
                                        .foregroundColor(.blue)
                                }
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                            }
                        }
            }
            .toolbarBackground(.white, for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            
        }
        
    }
}

#Preview {
    HomeScreenView()
}
