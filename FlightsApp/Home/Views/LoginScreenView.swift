import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct LoginScreenView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)

                LoginSheetView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadLoginStateIfNeeded()
            }
            .onChange(of: viewModel.isLoggedIn) { oldValue, newValue in
                if newValue {
                    print("User is logged in. Dismissing LoginScreenView.")
                    dismiss()
                } else {
                    print("User is logged out or automatic login failed.")
                }
            }
            .sheet(isPresented: $viewModel.showRegisterScreen) {
                RegisterScreenView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
