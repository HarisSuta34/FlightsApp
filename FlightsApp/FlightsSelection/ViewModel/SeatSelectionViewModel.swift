import Foundation

class SeatSelectionViewModel: ObservableObject {
        
    @Published var seats: [Seat] = []
    @Published var selectedSeats: [Seat] = []
    @Published var showingAlert = false
    @Published var alertMessage = ""
        
    private let numberOfTravelers: Int
    private let rows = 20
    private let columns = ["A", "B", "C", "D", "E", "F"]
    
    var isSelectionValid: Bool {
        selectedSeats.count == numberOfTravelers
    }
    
    var headerText: String {
        "Select Your Seats (\(selectedSeats.count) of \(numberOfTravelers))"
    }
        
    init(numberOfTravelers: Int, initialSelectedSeats: [Seat] = []) {
        self.numberOfTravelers = numberOfTravelers
        self.generateSeats(initialSelectedSeats: initialSelectedSeats)
        self.selectedSeats = self.seats.filter { $0.status == .selected }
    }
        
    func handleSeatSelection(selectedSeat: Seat) {
        if selectedSeat.status == .occupied {
            showingAlert = true
            alertMessage = "This seat is already occupied. Please select an available seat."
            return
        }
        
        if let index = seats.firstIndex(where: { $0.id == selectedSeat.id }) {
            if seats[index].status == .selected {
                seats[index].status = .available
                selectedSeats.removeAll { $0.id == selectedSeat.id }
            } else {
                if selectedSeats.count < numberOfTravelers {
                    seats[index].status = .selected
                    selectedSeats.append(seats[index])
                } else {
                    showingAlert = true
                    alertMessage = "You can only select a total of \(numberOfTravelers) seats."
                }
            }
        }
    }
    
    func getSeat(row: Int, column: String) -> Seat {
        seats.first { $0.row == row && $0.column == column } ?? Seat(row: row, column: column, status: .occupied)
    }
    
    func resetSeats() {
        self.selectedSeats = []
        generateSeats(initialSelectedSeats: [])
    }
        
    private func generateSeats(initialSelectedSeats: [Seat]) {
        var newSeats: [Seat] = []
        let totalSeats = rows * columns.count
        
        var occupiedSeatNumbers: [String] = []
        let occupiedCount = Int.random(in: totalSeats / 4...totalSeats / 3)
        let initialSelectedSeatNumbers = initialSelectedSeats.map { $0.seatNumber }
        
        var allSeatNumbers: [String] = []
        for row in 1...rows {
            for column in columns {
                let seatNumber = "\(row)\(column)"
                if !initialSelectedSeatNumbers.contains(seatNumber) {
                    allSeatNumbers.append(seatNumber)
                }
            }
        }
        allSeatNumbers.shuffle()
        occupiedSeatNumbers = Array(allSeatNumbers.prefix(occupiedCount))
        
        for row in 1...rows {
            for column in columns {
                let seatNumber = "\(row)\(column)"
                var status: SeatStatus
                
                if initialSelectedSeatNumbers.contains(seatNumber) {
                    status = .selected
                } else if occupiedSeatNumbers.contains(seatNumber) {
                    status = .occupied
                } else {
                    status = .available
                }
                newSeats.append(Seat(row: row, column: column, status: status))
            }
        }
        self.seats = newSeats
    }
}

enum SeatStatus: Codable {
    case available
    case occupied
    case selected
}
