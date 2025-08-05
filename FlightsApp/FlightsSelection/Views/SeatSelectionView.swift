//
//  SeatSelectionView.swift
//  FlightsApp
//
//  Created by Haris Suta on 5. 8. 2025..
//

import SwiftUI

struct SeatSelectionView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Seat Selection")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Ovdje će biti prikaz sjedala za odabir.")
            
            Button("Select Seat") {
                status = .completed
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding()
        .navigationTitle("Seat Selection")
    }
}

#Preview {
    SeatSelectionView(status: .constant(.incomplete))
}
