//
//  FlightOffersViewModel.swift
//

import Foundation
import SwiftUI

// MARK: - ViewModel to handle data fetching, calculation, and filtering
class FlightOffersViewModel: ObservableObject {
    @Published var flightOffers: [FlightOffer] = []
    @Published var isLoading = false
    
    private var fromCity: String
    private var toCity: String
    private var adults: Int
    private var kids: Int
    private var flightClass: String
    
    private var initialFlightOffers: [FlightOffer] = []
    
    private let baseOffers: [FlightOffer] = [
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Qatar Airways", price: 235),
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Ryanair", price: 127),
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Lufthansa", price: 280),
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Lufthansa", price: 250),
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Austrian Airlines", price: 220),
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Turkish Airlines", price: 300),
        FlightOffer(departureCity: "", arrivalCity: "", airline: "Alitalia", price: 180),
    ]
    
    init(fromCity: String, toCity: String, adults: Int, kids: Int, flightClass: String) {
        self.fromCity = fromCity
        self.toCity = toCity
        self.adults = adults
        self.kids = kids
        self.flightClass = flightClass
        
        fetchOffers()
    }
    
    private func getClassMultiplier() -> Double {
        switch flightClass {
        case "Premium Economy":
            return 1.5
        case "Business":
            return 2.0
        case "First Class":
            return 2.5
        default:
            return 1.0
        }
    }
    
    private func calculatePrice(basePrice: Double) -> Double {
        let classMultiplier = getClassMultiplier()
        let adultPrice = Double(adults) * basePrice * classMultiplier
        let kidPrice = Double(kids) * basePrice * classMultiplier * 0.5
        return adultPrice + kidPrice
    }
    
    func fetchOffers() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let allOffersWithCalculatedPrice = self.baseOffers.map { baseOffer in
                let newPrice = self.calculatePrice(basePrice: baseOffer.price)
                return FlightOffer(
                    departureCity: self.fromCity,
                    arrivalCity: self.toCity,
                    airline: baseOffer.airline,
                    price: newPrice
                )
            }
            
            let randomOfferCount = Int.random(in: 0...allOffersWithCalculatedPrice.count)
            let selectedOffers = Array(allOffersWithCalculatedPrice.shuffled().prefix(randomOfferCount))
            
            self.initialFlightOffers = selectedOffers
            
            self.flightOffers = self.initialFlightOffers
            
            self.isLoading = false
        }
    }
    
    func applyFilters(filters: FilterOptions) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flightOffers = self.initialFlightOffers.filter { offer in
                return offer.price <= filters.maxPrice
            }
            
            self.isLoading = false
        }
    }
}
