import SwiftUI


struct AccountDetailRowView: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.blue)
                .padding(.trailing, 10)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(value)
                    .font(.body)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    AccountDetailRowView(title: "Email", value: "user@example.com", icon: "envelope.fill")
}
