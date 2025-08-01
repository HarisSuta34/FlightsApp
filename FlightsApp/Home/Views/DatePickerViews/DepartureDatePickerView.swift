//
//  DepartureDatePickerView.swift
//  FlightsApp
//
//  Created by Haris Suta on 1. 8. 2025..
//

import SwiftUI

struct DepartureDatePickerView: View {
    
    @ObservedObject var homeScreenViewModel: HomeScreenViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") { homeScreenViewModel.showingDepartureDatePicker = false }
                .padding()
                Spacer()
                Button("Done") { homeScreenViewModel.showingDepartureDatePicker = false }
                .padding()
            }
            DatePicker(
                "Choose departure date",
                selection: $homeScreenViewModel.departureDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }
}

#Preview {
    DepartureDatePickerView(homeScreenViewModel: HomeScreenViewModel())
}
