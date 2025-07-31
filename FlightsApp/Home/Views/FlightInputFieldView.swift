import SwiftUI

struct FlightInputFieldView: View {
    let title: String
    let mainText: String
    let subText: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(mainText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
            }
            if !subText.isEmpty {
                Text(subText)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    FlightInputFieldView(
        title: "From",
        mainText: "Sarajevo (SJJ)",
        subText: "Sarajevo International Airport",
        icon: "airplane.departure"
    )
}
