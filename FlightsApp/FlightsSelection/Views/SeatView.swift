//
//  SeatView.swift
//  FlightsApp
//
//  Created by Haris Suta on 6. 8. 2025..
//

import SwiftUI

struct SeatView: View {
    let seat: Seat
    let action: (Seat) -> Void
    
    var body: some View {
        Button(action: {
            action(seat)
        }) {
            VStack {
                Image(systemName: "chair.fill")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(seatColor)
                Text(seat.column)
                    .font(.caption2)
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
        .disabled(seat.status == .occupied)
    }
    
    private var seatColor: Color {
        switch seat.status {
        case .available:
            return .blue
        case .occupied:
            return .gray
        case .selected:
            return .green
        }
    }
}

#Preview {
    SeatView(seat: Seat(row: 1, column: "A", status: .available), action: { _ in })
            .background(Color(red: 36/255, green: 97/255, blue: 223/255))
}
