import SwiftUI

struct PlaceholderOffersView: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "airplane.circle")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            Text("Search for a flight on the Home tab to see offers.")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .navigationTitle("Offers")
    }
}
