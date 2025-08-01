import SwiftUI

struct OfferCardView: View {
    let backgroundColor: Color
    let textColor: Color
    let icon: Image
    let discount: String
    let brand: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(textColor)
                Text(brand)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                Spacer()
            }
            Text(discount)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(textColor)
            Text(description)
                .font(.caption)
                .foregroundColor(textColor.opacity(0.7))
                .lineLimit(2)
        }
        .padding()
        .frame(width: 180, height: 150)
        .background(backgroundColor)
        .cornerRadius(15)
    }
}

#Preview {
    OfferCardView(
        backgroundColor: Color(red: 255/255, green: 230/255, blue: 230/255),
        textColor: .black,
        icon: Image(systemName: "creditcard.fill"), 
        discount: "15% OFF",
        brand: "Mastercard",
        description: "Lorem ipsum dolor sit amet etet adip"
    )
}
