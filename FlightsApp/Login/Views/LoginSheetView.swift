import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import FirebaseAuth

struct LoginSheetView: View {
    @ObservedObject var viewModel: LoginScreenViewModel
    
    @FocusState private var focusedField: Field?
    enum Field: Hashable {
        case email
        case password
    }

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 5)
            
            Text("Welcome back to the app")
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.emailValidationError != nil ? Color.red : Color.clear, lineWidth: 1)
                    )
                if let error = viewModel.emailValidationError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                }
                
                HStack {
                    ZStack {
                        SecureField("Password", text: $viewModel.password)
                            .opacity(viewModel.showPassword ? 0 : 1)
                            .disabled(viewModel.showPassword)
                        
                        TextField("Password", text: $viewModel.password)
                            .opacity(viewModel.showPassword ? 1 : 0)
                            .disabled(!viewModel.showPassword)
                    }
                    .animation(.none, value: viewModel.showPassword)

                    Button {
                        viewModel.showPassword.toggle()
                    } label: {
                        Image(systemName: viewModel.showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
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
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(viewModel.passwordValidationError != nil ? Color.red : Color.clear, lineWidth: 1)
                )

                if let error = viewModel.passwordValidationError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.forgotPasswordEmail = viewModel.email
                        viewModel.forgotPasswordMessage = nil
                        viewModel.showForgotPasswordSheet = true
                    }) {
                        Text("Forgot Password?")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
                
                Toggle(isOn: $viewModel.keepSignedIn) {
                    Text("Keep me signed in")
                }
                .toggleStyle(CheckboxToggleStyle())
                .foregroundColor(.black)
                
                Button(action: {
                    viewModel.emailFieldTouched = true
                    viewModel.passwordFieldTouched = true
                    viewModel.login()
                }) {
                    if viewModel.isLoadingAuth {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    } else {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isLoginButtonEnabled ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }
                .disabled(!viewModel.isLoginButtonEnabled || viewModel.isLoadingAuth)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Text("or sign in with")
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
                
                GoogleSignInButton() {
                    DispatchQueue.main.async {
                        if let presentingVC = getRootViewController() {
                            viewModel.isLoadingAuth = true // Set loading state before Google sign-in
                            GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { result, error in
                                viewModel.handleGoogleSignInResult(user: result?.user, error: error)
                            }
                        } else {
                            print("ERROR: Could not get root view controller for Google Sign-In presentation.")
                            viewModel.errorMessage = "Greška pri prikazu Google prijave."
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                
                Button(action: {
                    viewModel.showRegisterScreen = true
                }) {
                    Text("Create an account")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)
                
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
        .sheet(isPresented: $viewModel.showForgotPasswordSheet) {
            ForgotPasswordSheetView(viewModel: viewModel)
        }
    }
    
    private func getRootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var root = window.rootViewController
        while let presentedVC = root?.presentedViewController {
            root = presentedVC
        }
        return root
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            configuration.label
        }
    }
}

#Preview {
    LoginSheetView(viewModel: LoginScreenViewModel(dataManager: LoginDataManager.shared))
}
