import SwiftUI
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore


struct HomeScreenView: View {
    @ObservedObject var homeScreenViewModel: HomeScreenViewModel
    
    @ObservedObject var loginScreenViewModel: LoginScreenViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)
            
            HomeSheetView(homeScreenViewModel: homeScreenViewModel, loginScreenViewModel: loginScreenViewModel)
            
            HomeTitleView()
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $homeScreenViewModel.showingDepartureDatePicker) {
            DepartureDatePickerView(homeScreenViewModel: homeScreenViewModel)
        }
        .sheet(isPresented: $homeScreenViewModel.showingReturnDatePicker) {
            ReturnDatePickerView(homeScreenViewModel: homeScreenViewModel)
        }
        .sheet(isPresented: $homeScreenViewModel.showingTravellerSelectionSheet) {
            TravellerSelectionView(
                showingSheet: $homeScreenViewModel.showingTravellerSelectionSheet,
                numberOfAdults: $homeScreenViewModel.numberOfAdults,
                numberOfKids: $homeScreenViewModel.numberOfKids
            )
        }
        .sheet(isPresented: $homeScreenViewModel.showingClassSelectionSheet) {
            FlightClassSelectionView(
                showingSheet: $homeScreenViewModel.showingClassSelectionSheet,
                selectedClass: $homeScreenViewModel.selectedClass
            )
        }
        .sheet(isPresented: $homeScreenViewModel.showingFromAirportSelection) {
            AirportSelectionView(selectedAirport: $homeScreenViewModel.fromAirport, airports: sampleAirports)
        }
        .sheet(isPresented: $homeScreenViewModel.showingToAirportSelection) {
            AirportSelectionView(selectedAirport: $homeScreenViewModel.toAirport, airports: sampleAirports)
        }
    }
}



#Preview {
    HomeScreenView(
        homeScreenViewModel: HomeScreenViewModel(),
        loginScreenViewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared)
        
    )
}
