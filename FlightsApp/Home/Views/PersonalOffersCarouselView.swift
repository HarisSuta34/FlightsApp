import SwiftUI

struct PersonalOffersCarouselView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                OfferCardView(
                    backgroundColor: Color(red: 255/255, green: 230/255, blue: 230/255),
                    textColor: .black,
                    icon: Image("mastercard"),
                    discount: "15% OFF",
                    brand: "mastercard",
                    description: "Pay with mastercard"
                )
                
                OfferCardView(
                    backgroundColor: Color(red: 230/255, green: 230/255, blue: 255/255),
                    textColor: .black,
                    icon: Image("visa1"),
                    discount: "23% OFF",
                    brand: "VISA",
                    description: "Pay with Visa"
                )
                
                OfferCardView(
                    backgroundColor: Color(red: 230/255, green: 255/255, blue: 230/255),
                    textColor: .black,
                    icon: Image("amex"),
                    discount: "10% OFF",
                    brand: "AMEX",
                    description: "Pay with Amex"
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    PersonalOffersCarouselView()
}
