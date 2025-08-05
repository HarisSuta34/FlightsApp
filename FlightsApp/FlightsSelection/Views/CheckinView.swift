//
//  CheckinView.swift
//  FlightsApp
//
//  Created by Haris Suta on 5. 8. 2025..
//

import SwiftUI

struct CheckinView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Online Check-in")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Ovdje će biti forma za unos podataka za putovnicu i opcija za upload slike.")
            
            Button("Complete Check-in") {
                status = .completed
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding()
        .navigationTitle("Online Check-in")
    }
}

#Preview {
    CheckinView(status: .constant(.incomplete))
}
