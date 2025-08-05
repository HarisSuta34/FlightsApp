//
//  PassengerDetailsView.swift
//  FlightsApp
//
//  Created by Haris Suta on 5. 8. 2025..
//

import SwiftUI

struct PassengerDetailsView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Passenger Details")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Ovdje će biti forma za unos podataka o putnicima.")
            
            Button("Save Details") {
                status = .completed
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding()
        .navigationTitle("Passenger Details")
    }
}

#Preview {
    PassengerDetailsView(status: .constant(.incomplete))
}
