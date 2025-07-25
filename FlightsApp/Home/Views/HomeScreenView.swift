import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var viewModel: LoginScreenViewModel 

    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)
            
            Text("Home")
                .font(.system(size: 80, weight: .bold, design: .default))
                .foregroundColor(.white)
                .padding(.bottom, 300)
        }
    }
}

#Preview {
    HomeScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
