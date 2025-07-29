import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

struct RegisterSheetView: View {
    
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @FocusState private var focusedField: Field?
    enum Field: Hashable {
        case email
        case password
    }

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
                    .focused($focusedField, equals: .email)
                    .onTapGesture {
                        viewModel.emailFieldTouched = true
                    }
                    .onChange(of: focusedField) { _, newFocus in
                        if newFocus != .email && viewModel.emailFieldTouched {
                            viewModel.validateEmailFormat()
                        }
                    }
                
                if let error = viewModel.emailValidationError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .focused($focusedField, equals: .password)
                    .onTapGesture {
                        viewModel.passwordFieldTouched = true
                    }
                    .onChange(of: focusedField) { _, newFocus in
                        if newFocus != .password && viewModel.passwordFieldTouched {
                            viewModel.validatePasswordLength()
                        }
                    }

                if let error = viewModel.passwordValidationError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                }
                
                Toggle(isOn: $viewModel.keepSignedIn) {
                    Text("Keep me signed in")
                }
                .toggleStyle(CheckboxToggleStyle())
                .foregroundColor(.black)
                .padding(.top, 5) 
                
                Button {
                    viewModel.emailFieldTouched = true
                    viewModel.passwordFieldTouched = true
                    viewModel.registerUser()
                } label: {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.isRegisterButtonEnabled ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!viewModel.isRegisterButtonEnabled)
                
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
        .onTapGesture {
            focusedField = nil
        }
        .onAppear {
            viewModel.emailFieldTouched = false
            viewModel.passwordFieldTouched = false
            viewModel.emailValidationError = nil
            viewModel.passwordValidationError = nil
        }
    }
}

#Preview {
    RegisterSheetView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
