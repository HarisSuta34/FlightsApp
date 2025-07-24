import SwiftUI

struct ProfileOptionRowView: View {
    let icon: String
    let title: String
    let subtitle: String
    var showChevron: Bool = true
    var showToggle: Bool = false
    @Binding var toggleState: Bool
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if showToggle {
                Toggle(isOn: $toggleState) {
                }
                .labelsHidden()
                .tint(.blue)
            } else if showChevron {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.white)
        .contentShape(Rectangle()) 
    }
}

#Preview {
    ProfileOptionRowView(icon: "person.fill", title: "Sample Option", subtitle: "This is a sample subtitle", toggleState: .constant(false))
}
