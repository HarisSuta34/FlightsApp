import SwiftUI

struct LoginScreenView: View {
    @EnvironmentObject var viewModel: LoginScreenViewModel
    
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
                    print("Korisnik je prijavljen. Zatvaram LoginScreenView.")
                    dismiss()
                } else {
                    print("Korisnik je odjavljen ili automatska prijava nije uspjela.")
                }
            }
            .sheet(isPresented: $viewModel.showRegisterScreen) {
                RegisterScreenView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginScreenView()
        .environmentObject(LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
