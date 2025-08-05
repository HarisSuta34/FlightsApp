import SwiftUI

struct FlightSelectionSheetView: View {
    let selectedFlightDetails: FlightDetails
    
    @Binding var passengerDetailsStatus: CompletionStatus
    @Binding var checkinStatus: CompletionStatus
    @Binding var seatStatus: CompletionStatus
    
    var body: some View {
        VStack(spacing: 0) {
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
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    let sampleOffer = FlightOffer(
        departureCity: "Mostar",
        arrivalCity: "Sarajevo",
        airline: "Fly Mostar",
        price: 150.0
    )
    let sampleFlightDetails = FlightDetails(flightOffer: sampleOffer)
    
    return FlightSelectionSheetView(
        selectedFlightDetails: sampleFlightDetails,
        passengerDetailsStatus: .constant(.incomplete),
        checkinStatus: .constant(.incomplete),
        seatStatus: .constant(.incomplete)
    )
    .background(Color(red: 36/255, green: 97/255, blue: 223/255))
}


