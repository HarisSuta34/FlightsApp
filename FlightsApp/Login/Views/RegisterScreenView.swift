import SwiftUI

struct RegisterScreenView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 36/255, green: 97/255, blue: 223/255)
                    .ignoresSafeArea(.all)
                
                RegisterSheetView(viewModel: viewModel)
            }
            .navigationTitle("Register")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .onChange(of: viewModel.isLoggedIn) { oldValue, newValue in
                if newValue {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    RegisterScreenView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
