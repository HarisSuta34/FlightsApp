import SwiftUI

struct HomeSheetView: View {
    
    @ObservedObject var homeScreenViewModel: HomeScreenViewModel
    
    @ObservedObject var loginScreenViewModel: LoginScreenViewModel
    
    @Binding var navigateToOffers: Bool
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 80)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Welcome back \(loginScreenViewModel.username ?? loginScreenViewModel.email.components(separatedBy: "@").first ?? "User").")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("Select destination we can fly you to.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    HStack(spacing: 0) {
                        Button(action: { homeScreenViewModel.selectedTripType = "One way" }) {
                            Text("One way")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(homeScreenViewModel.selectedTripType == "One way" ? .white : .black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                                .background(homeScreenViewModel.selectedTripType == "One way" ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                        Button(action: { homeScreenViewModel.selectedTripType = "Round" }) {
                            Text("Round")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(homeScreenViewModel.selectedTripType == "Round" ? .white : .black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .frame(maxWidth: .infinity)
                                .background(homeScreenViewModel.selectedTripType == "Round" ? Color.blue : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        homeScreenViewModel.showingFromAirportSelection = true
                    }) {
                        FlightInputFieldView(
                            title: "From",
                            mainText: homeScreenViewModel.fromAirport.city,
                            subText: "\(homeScreenViewModel.fromAirport.name) (\(homeScreenViewModel.fromAirport.code))",
                            icon: "airplane.departure"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            homeScreenViewModel.swapAirports()
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding(5)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .offset(y: -25)
                        Spacer()
                    }
                    
                    Button(action: {
                        homeScreenViewModel.showingToAirportSelection = true
                    }) {
                        FlightInputFieldView(
                            title: "To",
                            mainText: homeScreenViewModel.toAirport.city,
                            subText: "\(homeScreenViewModel.toAirport.name) (\(homeScreenViewModel.toAirport.code))",
                            icon: "airplane.arrival"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .offset(y: -50)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            homeScreenViewModel.showingDepartureDatePicker = true
                        }) {
                            FlightInputFieldView(
                                title: "Departure",
                                mainText: homeScreenViewModel.formattedDepartureDate,
                                subText: "Pick date",
                                icon: "calendar"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            homeScreenViewModel.showingReturnDatePicker = true
                        }) {
                            FlightInputFieldView(
                                title: "Return",
                                mainText: homeScreenViewModel.formattedReturnDate,
                                subText: "",
                                icon: "calendar"
                            )
                            .frame(maxWidth: .infinity)
                            .opacity(homeScreenViewModel.selectedTripType == "One way" ? 0.5 : 1.0)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(homeScreenViewModel.selectedTripType == "One way")
                    }
                    .offset(y: -50)
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            homeScreenViewModel.showingTravellerSelectionSheet = true
                        }) {
                            FlightInputFieldView(
                                title: "Traveller",
                                mainText: homeScreenViewModel.travellerText,
                                subText: "",
                                icon: "person.fill"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            homeScreenViewModel.showingClassSelectionSheet = true
                        }) {
                            FlightInputFieldView(
                                title: "Class",
                                mainText: homeScreenViewModel.selectedClass,
                                subText: "",
                                icon: "tag.fill"
                            )
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .offset(y: -50)
                    
                    Button(action: {
                        self.navigateToOffers = true
                    }) {
                        Text("Search")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .offset(y: -40)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Personal offers")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            print("See all offers tapped!")
                        }) {
                            Text("See all")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    
                    PersonalOffersCarouselView()
                }
                .padding(.bottom, 20)
            }
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 0)
        }
    }
}

#Preview{
    @State @Previewable var navigateToOffers = false
    
    HomeSheetView(
        homeScreenViewModel: HomeScreenViewModel(),
        loginScreenViewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared),
        navigateToOffers: $navigateToOffers
    )
}
