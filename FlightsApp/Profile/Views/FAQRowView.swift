import SwiftUI

struct FAQRowView: View {
    let question: String
    let answer: String
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    Text(answer)
                        .font(.body)
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.top, 5)
                },
                label: {
                    Text(question)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            )
            .accentColor(.blue)
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

#Preview {
    FAQRowView(question: "Sample Question", answer: "This is a sample answer for the FAQ row.")
}
