//
//  FlightInfoCardView.swift
//  FlightsApp
//
//  Created by Haris Suta on 5. 8. 2025..
//

import SwiftUI

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


#Preview {
    let sampleOffer = FlightOffer(
        departureCity: "Mostar",
        arrivalCity: "Sarajevo",
        airline: "Fly Mostar",
        price: 150.0
    )
    let sampleFlightDetails = FlightDetails(flightOffer: sampleOffer)
    return FlightInfoCardView(flight: sampleFlightDetails)
}
