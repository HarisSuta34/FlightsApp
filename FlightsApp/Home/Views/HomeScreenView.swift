import SwiftUI
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore


struct HomeScreenView: View {
    @StateObject private  var homeScreenViewModel = HomeScreenViewModel()
    
    @ObservedObject var loginScreenViewModel: LoginScreenViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)
            
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
                                // Zamjena aerodroma poziva se iz ViewModela
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
                        
                        // Dugme za odabir dolaznog aerodroma
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
                            print("Search button tapped!")
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
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                OfferCardView(
                                    backgroundColor: Color(red: 255/255, green: 230/255, blue: 230/255),
                                    textColor: .black,
                                    icon: Image("mastercard"),
                                    discount: "15% OFF",
                                    brand: "mastercard",
                                    description: "Pay with mastercard"
                                )
                                
                                OfferCardView(
                                    backgroundColor: Color(red: 230/255, green: 230/255, blue: 255/255),
                                    textColor: .black,
                                    icon: Image("visa1"),
                                    discount: "23% OFF",
                                    brand: "VISA",
                                    description: "Pay with Visa"
                                )
                                
                                OfferCardView(
                                    backgroundColor: Color(red: 230/255, green: 255/255, blue: 230/255),
                                    textColor: .black,
                                    icon: Image("amex"),
                                    discount: "10% OFF",
                                    brand: "AMEX",
                                    description: "Pay with Amex"
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.bottom, 20)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "airplane")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                    Text("FLY MOSTAR")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top, 70)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color(red: 36/255, green: 97/255, blue: 223/255))
            .ignoresSafeArea(.container, edges: .top)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $homeScreenViewModel.showingDepartureDatePicker) {
            VStack {
                HStack {
                    Button("Cancel") { homeScreenViewModel.showingDepartureDatePicker = false }
                    .padding()
                    Spacer()
                    Button("Done") { homeScreenViewModel.showingDepartureDatePicker = false }
                    .padding()
                }
                DatePicker(
                    "Choose departure date",
                    selection: $homeScreenViewModel.departureDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
            }
        }
        .sheet(isPresented: $homeScreenViewModel.showingReturnDatePicker) {
            VStack {
                HStack {
                    Button("Cancel") { homeScreenViewModel.showingReturnDatePicker = false }
                    .padding()
                    Spacer()
                    Button("Done") { homeScreenViewModel.showingReturnDatePicker = false }
                    .padding()
                }
                DatePicker(
                    "Choose return date",
                    selection: Binding(
                        get: { homeScreenViewModel.returnDate ?? homeScreenViewModel.departureDate },
                        set: { homeScreenViewModel.returnDate = $0 }
                    ),
                    in: homeScreenViewModel.departureDate...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
            }
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
    HomeScreenView(loginScreenViewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
