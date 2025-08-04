import SwiftUI

struct FilterOffersView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var filters: FilterOptions
    
    @State private var localMaxPrice: Double
    
    init(filters: Binding<FilterOptions>) {
        self._filters = filters
        self._localMaxPrice = State(initialValue: filters.wrappedValue.maxPrice)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Max Price: $\(String(format: "%.0f", localMaxPrice))")
                        .font(.headline)
                    
                    Slider(value: $localMaxPrice, in: 100...500, step: 10)
                        .tint(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                Button(action: {
                    filters.maxPrice = localMaxPrice
                    dismiss()
                }) {
                    Text("Apply Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Filter Offers")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}
