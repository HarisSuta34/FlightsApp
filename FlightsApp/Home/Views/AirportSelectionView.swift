//
//  AirportSelectionView.swift
//  FlightsApp
//
//  Created by Haris Suta on 31. 7. 2025..
//

import SwiftUI

struct AirportSelectionView: View {
    @Environment(\.dismiss) var dismiss // Varijabla za zatvaranje sheet-a
    @Binding var selectedAirport: Airport // Binding za aerodrom koji će biti odabran
    
    // Filterable list of airports
    let airports: [Airport]
    
    // State varijabla za pretragu
    @State private var searchText: String = ""
    
    // Filtrirana lista aerodroma na osnovu unosa u pretragu
    var filteredAirports: [Airport] {
        if searchText.isEmpty {
            return airports
        } else {
            return airports.filter {
                $0.city.localizedCaseInsensitiveContains(searchText) ||
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(filteredAirports) { airport in
                        Button(action: {
                            // Ažuriraj odabrani aerodrom i zatvori sheet
                            selectedAirport = airport
                            dismiss()
                        }) {
                            VStack(alignment: .leading) {
                                Text(airport.city)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text("\(airport.name) (\(airport.code))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Select Airport")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    // Dummy varijabla za preview
    AirportSelectionView(selectedAirport: .constant(sampleAirports[0]), airports: sampleAirports)
}
