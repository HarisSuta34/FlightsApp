import SwiftUI

struct FlightConfirmationScreen: View {

    let flightDetails: FlightDetails
    let passengerDetails: PassengerDetails
    let seatNumber: String

    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Booking Confirmed")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)

                VStack(spacing: 0) {
                    FlightSummaryView(flightDetails: flightDetails)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight])

                    DividerView()

                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Economy Class")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                                Text("\(passengerDetails.firstName) \(passengerDetails.lastName)")
                                    .font(.headline)
                                Text("\(getAgeFromDate(passengerDetails.dateOfBirth)) years, \(passengerDetails.gender)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(flightDetails.airline == "Qatar Airways" ? "AC006" : "FL\(flightDetails.id.uuidString.prefix(4).uppercased())")
                                    .font(.headline)
                                Text("Flight")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 10)
                        }

                        HStack {
                            Spacer()
                            Image(systemName: "qrcode")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding(.top, 15)
                                .padding(.bottom, 15)
                            Spacer()
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                }
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.bottom, 20)

                Button(action: {
                    print("Print Ticket button tapped")
                }) {
                    Text("Print Ticket")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Flight Confirmation")
        .navigationBarTitleDisplayMode(.inline)
    }

    // Pomoćna funkcija za izračunavanje godina
    private func getAgeFromDate(_ date: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return ageComponents.year ?? 0
    }
}

// Pomoćni View za liniju
struct DividerView: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .overlay(
                DottedShape()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.gray)
            )
            .padding(.horizontal, 10)
    }
}

// Pomoćni Shape za crtanje isprekidane linije
struct DottedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

// Pomoćni View za gornji dio kartice s detaljima leta
struct FlightSummaryView: View {
    let flightDetails: FlightDetails

    var body: some View {
        HStack {
            // Predpostavlja se da je slika dostupna u Assets
            AsyncImage(url: URL(string: flightDetails.imageURL)) { image in
                image.resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(flightDetails.airline)
                    .font(.headline)
                Text(flightDetails.date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()

            VStack(alignment: .trailing, spacing: 5) {
                HStack {
                    Text(flightDetails.departureTime)
                        .font(.headline)
                    Spacer().frame(width: 10)
                    Image(systemName: "airplane")
                        .foregroundColor(.blue)
                    Spacer().frame(width: 10)
                    Text(flightDetails.arrivalTime)
                        .font(.headline)
                }
                HStack {
                    Text(flightDetails.fromCity)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(flightDetails.toCity)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}



#Preview {
    let sampleFlightOffer = FlightOffer(
        departureCity: "MST",
        arrivalCity: "LGA",
        airline: "Qatar Airways",
        price: 150.0
    )
    let sampleFlightDetails = FlightDetails(flightOffer: sampleFlightOffer)
    
    let samplePassengerDetails = PassengerDetails(
        firstName: "Jane",
        lastName: "Doe",
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -24, to: Date())!,
        nationality: "Bosnia",
        gender: "Female"
    )
    
    return NavigationView {
        FlightConfirmationScreen(
            flightDetails: sampleFlightDetails,
            passengerDetails: samplePassengerDetails,
            seatNumber: "29A"
        )
    }
}
