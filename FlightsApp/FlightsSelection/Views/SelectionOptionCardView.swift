import SwiftUI

struct SelectionOptionCardView: View {
    let title: String
    let subtitle: String
    let iconName: String
    let status: CompletionStatus
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                HStack {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(status == .incomplete ? .red : .green)
                    
                    if status == .completed {
                        Text("COMPLETED")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    VStack(spacing: 20) {
        SelectionOptionCardView(
            title: "Passangers",
            subtitle: "Select passangers",
            iconName: "person.2.fill",
            status: .incomplete
        )
        
        SelectionOptionCardView(
            title: "Seat Selection",
            subtitle: "Select your seats",
            iconName: "chair.fill",
            status: .completed
        )
    }
    .padding()
    .background(Color.gray.opacity(0.2))
}
