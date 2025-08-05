import SwiftUI



struct FlightSelectionScreenView: View {
    
    @State private var passengerDetailsStatus: CompletionStatus = .incomplete
    @State private var checkinStatus: CompletionStatus = .incomplete
    @State private var seatStatus: CompletionStatus = .incomplete
    
    let selectedFlightOffer: FlightOffer
    
    var selectedFlightDetails: FlightDetails
    
    init(selectedOffer: FlightOffer) {
        self.selectedFlightOffer = selectedOffer
        self.selectedFlightDetails = FlightDetails(flightOffer: selectedOffer)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)
                
                VStack(spacing: 0) {
                    
                    FlightHeaderView(flight: selectedFlightDetails)
                        .padding(.top, 35)
                        .padding(.bottom, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            FlightInfoCardView(flight: selectedFlightDetails)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 15) {
                                SelectionOptionCardView(
                                    title: "Passenger Details",
                                    subtitle: "Update your passenger details",
                                    iconName: "person.fill",
                                    status: passengerDetailsStatus
                                )
                                
                                SelectionOptionCardView(
                                    title: "Check-in",
                                    subtitle: "You can checkin now",
                                    iconName: "checkmark.circle.fill",
                                    status: checkinStatus
                                )
                                
                                SelectionOptionCardView(
                                    title: "Upgrade Flight",
                                    subtitle: "Upgrade your flight class",
                                    iconName: "airplane.circle.fill",
                                    status: .incomplete
                                )
                                
                                SelectionOptionCardView(
                                    title: "Choose seat",
                                    subtitle: "incomplete",
                                    iconName: "chair.fill",
                                    status: seatStatus
                                )
                                
                                SelectionOptionCardView(
                                    title: "Baggage allowance",
                                    subtitle: "40kg checked baggage",
                                    iconName: "suitcase.fill",
                                    status: .completed
                                )
                                
                                SelectionOptionCardView(
                                    title: "Purchase additional baggage",
                                    subtitle: "Upgrade your baggage",
                                    iconName: "plus.circle.fill",
                                    status: .incomplete
                                )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                        
                    }
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    
                    Button(action: {
                    }) {
                        Text("Book Flight")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 36/255, green: 97/255, blue: 223/255))
                            .cornerRadius(12)
                    }
                    .padding(20)
                    .background(Color.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center) {
                        Text("Flight offers screen")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(
                Color(red: 36/255, green: 97/255, blue: 223/255),
                for: .navigationBar
            )
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct FlightHeaderView: View {
    let flight: FlightDetails
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(flight.fromCity.prefix(3).uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(flight.fromCity)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                Text("12:45 hours")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(flight.toCity.prefix(3).uppercased())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(flight.toCity)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 40)
    }
}

struct FlightInfoCardView: View {
    let flight: FlightDetails
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(flight.departureTime)
                        .font(.headline)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text("Date")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(flight.date)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            
            HStack {
                HStack(spacing: 10) {
                    Image("qatarAirwaysLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text(flight.airline)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Text("$\(flight.price, specifier: "%.0f")")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            HStack {
                TextField("Enter promo code", text: .constant(""))
                    .padding(8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Button(action: {
                }) {
                    Text("Apply")
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct SelectionOptionCardView: View {
    let title: String
    let subtitle: String
    let iconName: String
    let status: CompletionStatus
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(status == .incomplete ? .red : .green)
                    
                    if status == .completed {
                        Text("COMPLETED")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

enum CompletionStatus {
    case incomplete
    case completed
}

#Preview {
    let sampleOffer = FlightOffer(
        departureCity: "Mostar",
        arrivalCity: "Sarajevo",
        airline: "Fly Mostar",
        price: 150.0
    )
    return FlightSelectionScreenView(selectedOffer: sampleOffer)
}
