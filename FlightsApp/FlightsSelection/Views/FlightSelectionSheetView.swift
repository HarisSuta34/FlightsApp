import SwiftUI

enum CompletionStatus: String {
    case incomplete
    case completed
    
    var color: Color {
        self == .completed ? .green : .red
    }
}

// Uklonjena je PassportDetails definicija jer već postoji

struct FlightSelectionSheetView: View {
    let selectedFlightDetails: FlightDetails
    let numberOfTravelers: Int
    
    @State private var passengerDetailsStatus: CompletionStatus = .incomplete
    @State private var passengerDetails = PassengerDetails()
    
    @State private var checkinStatus: CompletionStatus = .incomplete
    @State private var seatStatus: CompletionStatus = .incomplete
    @State private var upgradeStatus: CompletionStatus = .incomplete
    @State private var baggageStatus: CompletionStatus = .incomplete
    @State private var additionalBaggageStatus: CompletionStatus = .incomplete
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var selectedSeats: [Seat] = []
    
    // State varijable za čuvanje podataka o putovnici
    @State private var passportInfo = PassportDetails()
    @State private var passportPhotoData: Data? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    FlightInfoCardView(flight: selectedFlightDetails)
                        .padding(.horizontal, 20)
                    
                    VStack(spacing: 15) {
                        NavigationLink(destination: PassengerDetailsView(
                            status: $passengerDetailsStatus,
                            details: $passengerDetails)) {
                            SelectionOptionCardView(
                                title: "Passenger Details",
                                subtitle: passengerDetailsStatus == .completed ? "Completed" : "Update your passenger details",
                                iconName: "person.fill",
                                status: passengerDetailsStatus
                            )
                        }
                        
                        NavigationLink(destination: CheckinView(
                            status: $checkinStatus,
                            passportDetails: $passportInfo,
                            selectedImageData: $passportPhotoData)) {
                            SelectionOptionCardView(
                                title: "Check-in",
                                subtitle: checkinStatus == .completed ? "Completed" : "You can checkin now",
                                iconName: "checkmark.circle.fill",
                                status: checkinStatus
                            )
                        }
                        
                        NavigationLink(destination: DummyOptionView(status: $upgradeStatus, title: "Upgrade Flight")) {
                            SelectionOptionCardView(
                                title: "Upgrade Flight",
                                subtitle: upgradeStatus == .completed ? "Completed" : "Upgrade your flight class",
                                iconName: "airplane.circle.fill",
                                status: upgradeStatus
                            )
                        }
                        
                        NavigationLink(destination: SeatSelectionView(
                            status: $seatStatus,
                            numberOfTravelers: numberOfTravelers,
                            selectedSeats: $selectedSeats)) {
                            SelectionOptionCardView(
                                title: "Choose seat",
                                subtitle: seatStatus == .completed ? "Completed" : "Select your seat",
                                iconName: "chair.fill",
                                status: seatStatus
                            )
                        }
                        
                        NavigationLink(destination: DummyOptionView(status: $baggageStatus, title: "Baggage allowance")) {
                            SelectionOptionCardView(
                                title: "Baggage allowance",
                                subtitle: baggageStatus == .completed ? "Completed" : "40kg checked baggage",
                                iconName: "suitcase.fill",
                                status: baggageStatus
                            )
                        }
                        
                        NavigationLink(destination: DummyOptionView(status: $additionalBaggageStatus, title: "Purchase additional baggage")) {
                            SelectionOptionCardView(
                                title: "Purchase additional baggage",
                                subtitle: additionalBaggageStatus == .completed ? "Completed" : "Upgrade your baggage",
                                iconName: "plus.circle.fill",
                                status: additionalBaggageStatus
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            
            Button(action: {
                if passengerDetailsStatus == .incomplete {
                    alertMessage = "Passenger details must be completed before booking."
                    showingAlert = true
                } else if seatStatus == .incomplete {
                    alertMessage = "You must select a seat before booking."
                    showingAlert = true
                } else {
                    print("Sve je OK, nastavljamo s bookingom!")
                }
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
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Missing Information"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
