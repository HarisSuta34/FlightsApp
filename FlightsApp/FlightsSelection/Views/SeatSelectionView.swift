import SwiftUI

struct SeatSelectionView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: SeatSelectionViewModel
    
    @Binding var selectedSeats: [Seat]
    
    init(status: Binding<CompletionStatus>, numberOfTravelers: Int, selectedSeats: Binding<[Seat]>) {
        _status = status
        _selectedSeats = selectedSeats
        _viewModel = StateObject(wrappedValue: SeatSelectionViewModel(numberOfTravelers: numberOfTravelers, initialSelectedSeats: selectedSeats.wrappedValue))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.headerText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Button("Reset Seats") {
                viewModel.resetSeats()
            }
            .padding(.top, -10)
            .foregroundColor(.white)
            .font(.subheadline)
            .underline()
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(1...20, id: \.self) { row in
                        HStack(spacing: 5) {
                            Text("\(row)")
                                .font(.caption)
                                .frame(width: 25)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                ForEach(["A", "B", "C", "D", "E", "F"], id: \.self) { column in
                                    SeatView(seat: viewModel.getSeat(row: row, column: column)) { selectedSeat in
                                        viewModel.handleSeatSelection(selectedSeat: selectedSeat)
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
                    selectedSeats = []
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
                    selectedSeats = viewModel.selectedSeats
                    status = .completed
                    dismiss()
                }) {
                    Text("Confirm Seats")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(viewModel.isSelectionValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isSelectionValid)
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.vertical)
        .background(Color(red: 36/255, green: 97/255, blue: 223/255).ignoresSafeArea())
        .navigationTitle("Seat Selection")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Invalid Selection"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    SeatSelectionView(status: .constant(.incomplete), numberOfTravelers: 2, selectedSeats: .constant([]))
}
