import Foundation


struct Airport: Identifiable {
    let id = UUID()
    let city: String
    let name: String
    let code: String
}


let sampleAirports: [Airport] = [
    Airport(city: "Mostar", name: "Mostar International Airport", code: "MST"),
    Airport(city: "New York", name: "LaGuardia Airport", code: "LGA"),
    Airport(city: "London", name: "Heathrow Airport", code: "LHR"),
    Airport(city: "Paris", name: "Charles de Gaulle Airport", code: "CDG"),
    Airport(city: "Tokyo", name: "Haneda Airport", code: "HND"),
    Airport(city: "Dubai", name: "Dubai International Airport", code: "DXB"),
    Airport(city: "Frankfurt", name: "Frankfurt Airport", code: "FRA"),
    Airport(city: "Amsterdam", name: "Amsterdam Airport Schiphol", code: "AMS"),
    Airport(city: "Rome", name: "Leonardo da Vinci–Fiumicino Airport", code: "FCO"),
    Airport(city: "Istanbul", name: "Istanbul Airport", code: "IST")
]
