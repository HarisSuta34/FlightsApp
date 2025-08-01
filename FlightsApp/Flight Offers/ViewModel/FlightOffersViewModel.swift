//
//  FlightOffersViewModel.swift
//

import Foundation
import SwiftUI

// MARK: - ViewModel to handle data fetching and filtering
class FlightOffersViewModel: ObservableObject {
    @Published var flightOffers: [FlightOffer] = []
    @Published var isLoading = false
    
    // Store all available offers
    private let allOffers: [FlightOffer] = [
        FlightOffer(departureCity: "Mostar", arrivalCity: "New York", airline: "Qatar Airways", price: 235),
        FlightOffer(departureCity: "Mostar", arrivalCity: "Zagreb", airline: "Ryanair", price: 127),
        FlightOffer(departureCity: "Mostar", arrivalCity: "Berlin", airline: "Lufthansa", price: 280),
        FlightOffer(departureCity: "Mostar", arrivalCity: "Frankfurt", airline: "Lufthansa", price: 250),
        FlightOffer(departureCity: "Mostar", arrivalCity: "Beč", airline: "Austrian Airlines", price: 220),
        FlightOffer(departureCity: "Mostar", arrivalCity: "Istanbul", airline: "Turkish Airlines", price: 300),
        FlightOffer(departureCity: "Mostar", arrivalCity: "Rim", airline: "Alitalia", price: 180),
    ]
    
    init() {
        // Fetch all offers on initialization
        fetchOffers()
    }
    
    // Method to simulate fetching all offers
    func fetchOffers() {
        isLoading = true
        // Simulate a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.flightOffers = self.allOffers
            self.isLoading = false
        }
    }
    
    // New filtering method based on FilterOptions
    func applyFilters(filters: FilterOptions) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flightOffers = self.allOffers.filter { $0.price <= filters.maxPrice }
            self.isLoading = false
        }
    }
}
