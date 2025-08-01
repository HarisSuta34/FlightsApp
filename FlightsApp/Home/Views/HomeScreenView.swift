import SwiftUI
import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

struct HomeScreenView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @State private var selectedTripType: String = "One way"
    @State private var fromLocation: String = "Mostar"
    @State private var fromAirportCode: String = "MST"
    @State private var fromAirportName: String = "Mostar International Airport"
    @State private var toLocation: String = "New York"
    @State private var toAirportCode: String = "LGA"
    @State private var toAirportName: String = "Subhash Chandra International Airport"
    @State private var departureDate: Date = Calendar.current.date(from: DateComponents(year: 2022, month: 7, day: 15)) ?? Date()
    @State private var returnDate: Date? = nil
    
    @State private var numberOfAdults: Int = 1
    @State private var numberOfKids: Int = 0
    
    @State private var selectedClass: String = "Economy"

    @State private var showingDepartureDatePicker: Bool = false
    @State private var showingReturnDatePicker: Bool = false
    @State private var showingTravellerSelectionSheet: Bool = false
    // NOVO: State varijabla za kontrolu prikaza sheet-a za klasu
    @State private var showingClassSelectionSheet: Bool = false

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func travellerText() -> String {
        var parts: [String] = []
        if numberOfAdults > 0 {
            parts.append("\(numberOfAdults) Adult\(numberOfAdults > 1 ? "s" : "")")
        }
        if numberOfKids > 0 {
            parts.append("\(numberOfKids) Kid\(numberOfKids > 1 ? "s" : "")")
        }
        return parts.isEmpty ? "0 Travellers" : parts.joined(separator: ", ")
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 80)

                    VStack(alignment: .leading, spacing: 15) {
                        Text("Welcome back \(viewModel.username ?? viewModel.email.components(separatedBy: "@").first ?? "User").")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("Select destination we can fly you to.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)

                        HStack(spacing: 0) {
                            Button(action: { selectedTripType = "One way" }) {
                                Text("One way")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedTripType == "One way" ? .white : .black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTripType == "One way" ? Color.blue : Color.clear)
                                    .cornerRadius(8)
                            }
                            Button(action: { selectedTripType = "Round" }) {
                                Text("Round")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedTripType == "Round" ? .white : .black)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(selectedTripType == "Round" ? Color.blue : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.bottom, 10)

                        FlightInputFieldView(
                            title: "From",
                            mainText: "\(fromLocation) \(fromAirportCode)",
                            subText: fromAirportName,
                            icon: "airplane.departure"
                        )

                        HStack {
                            Spacer()
                            Button(action: {
                                let tempLocation = fromLocation
                                let tempCode = fromAirportCode
                                let tempName = fromAirportName

                                fromLocation = toLocation
                                fromAirportCode = toAirportCode
                                fromAirportName = toAirportName

                                toLocation = tempLocation
                                toAirportCode = tempCode
                                toAirportName = tempName
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

                        FlightInputFieldView(
                            title: "To",
                            mainText: "\(toLocation) \(toAirportCode)",
                            subText: toAirportName,
                            icon: "airplane.arrival"
                        )
                        .offset(y: -50)

                        HStack(spacing: 15) {
                            // Departure Date
                            Button(action: {
                                showingDepartureDatePicker = true
                            }) {
                                FlightInputFieldView(
                                    title: "Departure",
                                    mainText: formattedDate(departureDate),
                                    subText: "Pick date",
                                    icon: "calendar"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                showingReturnDatePicker = true
                            }) {
                                FlightInputFieldView(
                                    title: "Return",
                                    mainText: returnDate.map { formattedDate($0) } ?? "+ Add return date",
                                    subText: "",
                                    icon: "calendar"
                                )
                                .frame(maxWidth: .infinity)
                                .opacity(selectedTripType == "One way" ? 0.5 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(selectedTripType == "One way")
                        }
                        .offset(y: -50)

                        HStack(spacing: 15) {
                            Button(action: {
                                showingTravellerSelectionSheet = true
                            }) {
                                FlightInputFieldView(
                                    title: "Traveller",
                                    mainText: travellerText(),
                                    subText: "",
                                    icon: "person.fill"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                showingClassSelectionSheet = true
                            }) {
                                FlightInputFieldView(
                                    title: "Class",
                                    mainText: selectedClass,
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
                                    description: "Lorem ipsum dolor sit amet etet adip"
                                )

                                OfferCardView(
                                    backgroundColor: Color(red: 230/255, green: 230/255, blue: 255/255),
                                    textColor: .black,
                                    icon: Image("visa1"),
                                    discount: "23% OFF",
                                    brand: "VISA",
                                    description: "Lorem ipsum dolor sit amet etet adip"
                                )

                                OfferCardView(
                                    backgroundColor: Color(red: 230/255, green: 255/255, blue: 230/255),
                                    textColor: .black,
                                    icon: Image("amex"),
                                    discount: "10% OFF",
                                    brand: "AMEX",
                                    description: "Lorem ipsum dolor sit amet etet adip"
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
        .sheet(isPresented: $showingDepartureDatePicker) {
            VStack {
                HStack {
                    Button("Cancel") {
                        showingDepartureDatePicker = false
                    }
                    .padding()
                    Spacer()
                    Button("Done") {
                        showingDepartureDatePicker = false
                    }
                    .padding()
                }
                DatePicker(
                    "Odaberite datum polaska",
                    selection: $departureDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
            }
        }
        .sheet(isPresented: $showingReturnDatePicker) {
            VStack {
                HStack {
                    Button("Cancel") {
                        showingReturnDatePicker = false
                    }
                    .padding()
                    Spacer()
                    Button("Done") {
                        showingReturnDatePicker = false
                    }
                    .padding()
                }
                DatePicker(
                    "Odaberite datum povratka",
                    selection: Binding(
                        get: { returnDate ?? departureDate },
                        set: { returnDate = $0 }
                    ),
                    in: departureDate...,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
            }
        }
        .sheet(isPresented: $showingTravellerSelectionSheet) {
            TravellerSelectionView(
                showingSheet: $showingTravellerSelectionSheet,
                numberOfAdults: $numberOfAdults,
                numberOfKids: $numberOfKids
            )
        }
        .sheet(isPresented: $showingClassSelectionSheet) {
            FlightClassSelectionView(
                showingSheet: $showingClassSelectionSheet,
                selectedClass: $selectedClass
            )
        }
    }
}

#Preview {
    HomeScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
