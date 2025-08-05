import SwiftUI

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

#Preview {
    
    let sampleOffer = FlightOffer(
        departureCity: "Mostar",
        arrivalCity: "Sarajevo",
        airline: "Fly Mostar",
        price: 150.0
    )
    let sampleFlightDetails = FlightDetails(flightOffer: sampleOffer)
    FlightHeaderView(flight: sampleFlightDetails)
}
