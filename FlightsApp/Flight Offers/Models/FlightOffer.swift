import Foundation

// MARK: - A simple model for a flight offer
struct FlightOffer: Identifiable {
    let id = UUID()
    let departureCity: String
    let arrivalCity: String
    let airline: String
    let price: Double
}
