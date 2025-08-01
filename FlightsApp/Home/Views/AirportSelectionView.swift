import SwiftUI

struct AirportSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAirport: Airport
    
    let airports: [Airport]
    
    @State private var searchText: String = ""
    
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
    AirportSelectionView(selectedAirport: .constant(sampleAirports[0]), airports: sampleAirports)
}
