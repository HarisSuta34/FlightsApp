//
//  DummyOptionView.swift
//  FlightsApp
//
//  Created by Haris Suta on 5. 8. 2025..
//

import SwiftUI

struct DummyOptionView: View {
    @Binding var status: CompletionStatus
    @Environment(\.dismiss) var dismiss
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is temporary screen for option'\(title)'.")
            
            Button("Complete \(title)") {
                status = .completed
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
        .padding()
        .navigationTitle(title)
    }
}

#Preview {
    DummyOptionView(status: .constant(.incomplete), title: "Test dummy view")
}
