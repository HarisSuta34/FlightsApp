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
                    
                    FlightSelectionSheetView(
                        selectedFlightDetails: selectedFlightDetails,
                        passengerDetailsStatus: $passengerDetailsStatus,
                        checkinStatus: $checkinStatus,
                        seatStatus: $seatStatus
                    )
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





