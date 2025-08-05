import Foundation

struct FlightDetails: Identifiable {
    let id: UUID
    let fromCity: String
    let toCity: String
    let departureTime: String
    let arrivalTime: String
    let airline: String
    let price: Double
    let date: String
    let imageURL: String

    init(flightOffer: FlightOffer) {
        self.id = flightOffer.id
        self.fromCity = flightOffer.departureCity
        self.toCity = flightOffer.arrivalCity
        self.airline = flightOffer.airline
        self.price = flightOffer.price
        
        self.departureTime = "09:30 AM"
        self.arrivalTime = "05:00 PM"
        self.date = "15/07/2023"
        self.imageURL = "https://images.unsplash.com/photo-1542382900-512c1b973c91"
    }
}
