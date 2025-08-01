import SwiftUI

struct HomeTitleView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "airplane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
                Text("FLY MOSTAR")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.top, 70)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 36/255, green: 97/255, blue: 223/255))
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    HomeTitleView()
}
