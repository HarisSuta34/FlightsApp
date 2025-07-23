import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct RegisterSheetView: View {
    
    @ObservedObject var viewModel: LoginScreenViewModel
    
    var body: some View {
        VStack {
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 30)
            
            VStack(spacing: 20) {
                TextField("Email Address", text: $viewModel.email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                Button {
                    viewModel.registerUser()
                } label: {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            
            Spacer()
            
        }
    }
}
