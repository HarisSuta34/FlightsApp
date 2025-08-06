import SwiftUI

enum SeatStatus {
    case available
    case occupied
    case selected
}




struct SeatSelectionView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    let numberOfTravelers: Int
    
    @State private var seats: [Seat] = []
    @State private var selectedSeats: [Seat] = []
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private let rows = 20
    private let columns = ["A", "B", "C", "D", "E", "F"]
    
    private var isSelectionValid: Bool {
        selectedSeats.count == numberOfTravelers
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Seats (\(selectedSeats.count) of \(numberOfTravelers))")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(1...rows, id: \.self) { row in
                        HStack(spacing: 5) {
                            Text("\(row)")
                                .font(.caption)
                                .frame(width: 25)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                ForEach(columns, id: \.self) { column in
                                    SeatView(seat: getSeat(row: row, column: column)) { selectedSeat in
                                        handleSeatSelection(selectedSeat: selectedSeat)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .padding(.horizontal)
            
            HStack(spacing: 20) {
                Button(action: {
                    status = .incomplete
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    status = .completed
                    dismiss()
                }) {
                    Text("Confirm Seats")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isSelectionValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isSelectionValid)
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.vertical)
        .background(Color(red: 36/255, green: 97/255, blue: 223/255).ignoresSafeArea())
        .navigationTitle("Seat Selection")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            generateSeats()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Selection"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Helper funkcije
    
    private func generateSeats() {
        var newSeats: [Seat] = []
        let totalSeats = rows * columns.count
        let occupiedCount = Int.random(in: totalSeats / 4...totalSeats / 3)
        
        var allSeatNumbers: [String] = []
        for row in 1...rows {
            for column in columns {
                allSeatNumbers.append("\(row)\(column)")
            }
        }
        allSeatNumbers.shuffle()
        
        let occupiedSeatNumbers = Array(allSeatNumbers.prefix(occupiedCount))
        
        for row in 1...rows {
            for column in columns {
                let seatNumber = "\(row)\(column)"
                let status: SeatStatus = occupiedSeatNumbers.contains(seatNumber) ? .occupied : .available
                newSeats.append(Seat(row: row, column: column, status: status))
            }
        }
        self.seats = newSeats
    }
    
    private func getSeat(row: Int, column: String) -> Seat {
        seats.first { $0.row == row && $0.column == column } ?? Seat(row: row, column: column, status: .occupied)
    }
    
    private func handleSeatSelection(selectedSeat: Seat) {
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
                    selectedSeats.append(selectedSeat)
                } else {
                    showingAlert = true
                    alertMessage = "You can only select a total of \(numberOfTravelers) seats."
                }
            }
        }
    }
}




#Preview {
    SeatSelectionView(status: .constant(.incomplete), numberOfTravelers: 2)
}
