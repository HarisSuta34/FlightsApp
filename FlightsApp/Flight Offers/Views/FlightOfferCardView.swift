import SwiftUI

// MARK: - A view that displays a single flight offer card
struct FlightOfferCardView: View {
    let offer: FlightOffer
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(offer.departureCity.prefix(3).uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(offer.departureCity)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Text("12:45 hours")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 0) {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 8, height: 8)
                        
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        
                        ZStack {
                            Circle()
                                .fill(Color(red: 26/255, green: 115/255, blue: 232/255))
                                .frame(width: 30, height: 30)
                            Image(systemName: "airplane")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 18, height: 18)
                                .foregroundColor(.white)
                        }
                        
                        Line()
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 8, height: 8)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(offer.arrivalCity.prefix(3).uppercased())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(offer.arrivalCity)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding([.horizontal, .top])
            
            Divider()
            
            HStack {
                Text(offer.airline)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text("$\(String(format: "%.0f", offer.price))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: offer.price < 200 ? 2 : 0)
        )
    }
}
