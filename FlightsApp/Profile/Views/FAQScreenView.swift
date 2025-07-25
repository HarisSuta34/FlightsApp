
import SwiftUI


struct FAQScreenView: View {
  
    let faqItems: [FAQItem] = [
        FAQItem(question: "How can I track my flight?",
                answer: "You can track your flight by entering the flight number or flight route in the 'My Flights' section. The app will provide you with real-time updates on your flight status, including delays, gate changes, and arrival times."),
        FAQItem(question: "Can I change my flight date after purchasing a ticket?",
                answer: "The possibility of changing your flight date depends on your ticket's terms and conditions and the airline's policy. Please check your reservation details or contact our support for more information. Change fees may apply."),
        FAQItem(question: "How do I add luggage to my reservation?",
                answer: "You can usually add luggage during the booking process. If you have already purchased your ticket, you can add luggage via the 'Manage Reservation' section or directly on the airline's website."),
        FAQItem(question: "What payment options are available?",
                answer: "We accept a wide range of payment options, including credit/debit cards (Visa, MasterCard, American Express), PayPal, and other local payment methods. All transactions are secure and encrypted."),
        FAQItem(question: "What should I do if my flight is canceled or delayed?",
                answer: "In case of flight cancellation or significant delay, the airline will usually notify you via email or SMS. Our app will also display the updated status. Please follow the airline's instructions for rebooking or refunds."),
        FAQItem(question: "Can I book a hotel or rent a car through the app?",
                answer: "Currently, our app focuses on flight booking. However, we are working on integrating partner services for hotels and car rentals to provide you with a comprehensive travel experience. Stay tuned for our updates!"),
        FAQItem(question: "How can I contact customer support?",
                answer: "You can contact our customer support through the 'Help & Support' section in the app, via email at support@flightsapp.com, or by calling our toll-free number. Our team is available 24/7 to assist you.")
    ]
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Frequently Asked Questions (FAQ)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                            .padding(.horizontal)
                        
                        ForEach(faqItems) { item in
                            FAQRowView(question: item.question, answer: item.answer)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("FAQs")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("FAQs")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .tint(.white)
        }
    }
}

#Preview {
    NavigationView {
        FAQScreenView()
    }
}
