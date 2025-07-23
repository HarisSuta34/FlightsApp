import SwiftUI

struct ProfileScreenView: View {
    @EnvironmentObject var loginViewModel: LoginScreenViewModel

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Welcome to your profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()

                Text("You are Singed in as: \(loginViewModel.email)")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)
                
                Button("Log out") {
                    loginViewModel.logout()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 36/255, green: 97/255, blue: 223/255))
            .ignoresSafeArea(.all)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileScreenView()
        .environmentObject(LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
