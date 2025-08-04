import SwiftUI
import Foundation
import Combine

class HomeScreenViewModel: ObservableObject {
    
    @Published var selectedTripType: String = "One way"
    @Published var fromAirport: Airport = sampleAirports[0]
    @Published var toAirport: Airport = sampleAirports[1]
    
    @Published var departureDate: Date = Date()
    @Published var returnDate: Date? = nil
    
    @Published var numberOfAdults: Int = 1
    @Published var numberOfKids: Int = 0
    
    @Published var selectedClass: String = "Economy"
    
    @Published var showingDepartureDatePicker: Bool = false
    @Published var showingReturnDatePicker: Bool = false
    @Published var showingTravellerSelectionSheet: Bool = false
    @Published var showingClassSelectionSheet: Bool = false
    @Published var showingFromAirportSelection: Bool = false
    @Published var showingToAirportSelection: Bool = false
    
    var formattedDepartureDate: String {
        return formattedDate(departureDate)
    }
    
    var formattedReturnDate: String {
        return returnDate.map { formattedDate($0) } ?? "+ Add return date"
    }
    
    var travellerText: String {
        var parts: [String] = []
        if numberOfAdults > 0 {
            parts.append("\(numberOfAdults) Adult\(numberOfAdults > 1 ? "s" : "")")
        }
        if numberOfKids > 0 {
            parts.append("\(numberOfKids) Kid\(numberOfKids > 1 ? "s" : "")")
        }
        return parts.isEmpty ? "0 Travellers" : parts.joined(separator: ", ")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    func swapAirports() {
        let tempAirport = fromAirport
        fromAirport = toAirport
        toAirport = tempAirport
    }
}
